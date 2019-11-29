require "csv"
class Device < ApplicationRecord
  validates :timestamp,            presence: true
  validates :device_serial_number, presence: true
  validates :device_type,          presence: true
  validates :status,               presence: true

  validates :device_type,          inclusion: { in: %w[gateway sensor] }
  validates :status,               inclusion: { in: %w[online offline] }

  scope :in_day, ->(day) { where("timestamp >= ? AND timestamp <= ?", "#{day} 00:00:00", "#{day} 23:59:59") }
  scope :type_and_status, ->(type, status) { where("device_type = ? AND status = ?", type, status) }
  scope :match_serial, ->(serial) { where("device_serial_number = ?", serial) }

  def self.get_devices(day)
    Device.in_day(day).group(:device_serial_number)
          .count.sort_by { |_key, value| value * -1 }
          .first(10)
  end

  def self.get_types(day, type, status)
    devices = Device.in_day(day).type_and_status(type, status)
    return 0 if devices.empty?

    devices.map { |device| device }.uniq!(&:device_serial_number).count
  end

  def self.create_records(file)
    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    csv_file = CSV.new(file.read, csv_options)
    csv_file.each do |row|
      Device.create(
        timestamp: row['timestamp'],
        device_serial_number: row['id'],
        device_type: row['type'],
        status: row['status']
      )
    end
  end

  def find_percentage(day, occurrence)
    day = (day.to_date - 7).to_s
    prev_occurrence = Device.in_day(day).match_serial(device_serial_number).count
    calculate_percentage(prev_occurrence, occurrence)
  end

  private

  def calculate_percentage(prev_o, occurrence)
    return "No previous record" if prev_o.zero?

    "#{((occurrence * 100) / prev_o) - 100}%"
  end
end

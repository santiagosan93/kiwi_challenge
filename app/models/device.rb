require "csv"
class Device < ApplicationRecord
  validates :timestamp,            presence: true
  validates :device_serial_number, presence: true
  validates :device_type,          presence: true
  validates :status,               presence: true

  validates :device_type,          inclusion: { in: %w[gateway sensor] }
  validates :status,               inclusion: { in: %w[online offline] }

  def self.get_devices(day)
    Device.where("timestamp >= ? AND timestamp <= ?","#{day} 00:00:00","#{day} 23:59:59")
          .group(:device_serial_number)
          .count.sort_by { |_key, value| value * -1 }
          .first(10)
  end

  def self.get_types(day, type, status)
    amount = Device.where(
      "timestamp >= ? AND timestamp <= ? AND device_type = ? AND status = ?",
      "#{day} 00:00:00",
      "#{day} 23:59:59",
      type,
      status
    )
    return 0 if amount.empty?

    amount.map { |device| device }.uniq!(&:device_serial_number).count
  end

  def find_percentage(day, occurrence)
    day = (day.to_date - 7).to_s
    prev_occurrence = Device.where(
      "timestamp >= ? AND timestamp <= ? AND device_serial_number = ?",
      "#{day} 00:00:00",
      "#{day} 23:59:59",
      device_serial_number
    ).count
    calculate_percentage(prev_occurrence, occurrence)
  end

  private

  def calculate_percentage(prev_o, occurrence)
    return "No previous record" if prev_o.zero?

    "#{((occurrence * 100) / prev_o) - 100}%"
  end
end

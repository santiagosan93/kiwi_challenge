require "csv"
class Device < ApplicationRecord
  validates :timestamp,            presence: true
  validates :device_serial_number, presence: true
  validates :device_type,          presence: true
  validates :status,               presence: true

  validates :device_type,          inclusion: { in: %w[gateway sensor] }
  validates :status,               inclusion: { in: %w[online offline] }

  def self.create_records(file_instance)
    # Since we recieve an ActionDispatch::Http::UploadedFile instance,
    # I decided to format that instance once again into a CSV file to keep
    # coherence with what was being sent originaly.

    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    csv_file = CSV.new(file_instance.read, csv_options) # <-- Makes CSV
    csv_file.each do |row|
      Device.create(
        timestamp: row['timestamp'],
        device_serial_number: row['id'],
        device_type: row['type'],
        status: row['status']
      )
    end
  end

  def self.popular_devices(day, sample_ids)
    device_and_occurrance = Device.where(
      "timestamp >= ? AND timestamp <= ? AND device_serial_number IN (?)",
      "#{day} 00:00:00", "#{day} 23:59:59", sample_ids
    ).map { |dev| dev }.uniq!(&:device_serial_number).map do |device|
      [device, sample_ids.find_index(device.device_serial_number)]
    end
    device_and_occurrance.sort_by { |_device, indexx| indexx }
  end

  def self.top_occurrences(day)
    # This method returns an ARRAY of arrays! array[0][0] => (device_serial_number)
    #                                         array[0][1] => (popularity)
    # I think im doing something wrong calling the
    # .first(10) last in the method chain. I think this, because I don't know
    # how to protect me from all the querys that are going to get fired once
    # I iterate over the returned array.
    Device.where(
      "timestamp >= ? AND timestamp <= ?",
      "#{day} 00:00:00",
      "#{day} 23:59:59"
    )
          .group(:device_serial_number)
          .count.sort_by { |_key, value| value * -1 }
          .first(10)
  end

  def self.top_occurrences_with_ids(day, sample_ids)
    Device.where(
      "timestamp >= ? AND timestamp <= ? AND device_serial_number in (?)",
      "#{day} 00:00:00",
      "#{day} 23:59:59",
      sample_ids
    )
          .group(:device_serial_number)
          .count.first(10)
  end

  def dif_percentage(ocurrence, prev_o)
    return "No previous record" if prev_o.zero?
    # raise

    "#{((ocurrence * 100) / prev_o) - 100}%"
  end
end

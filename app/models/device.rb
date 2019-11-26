require "csv"
class Device < ApplicationRecord
  validates :timestamp,       presence: true
  validates :device_id,       presence: true
  validates :device_type,     presence: true
  validates :status,          presence: true

  validates :device_type,     inclusion: { in: %w[gateway sensor] }
  validates :status,          inclusion: { in: %w[online offline] }

  def self.create_records(file)
    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    csv_file = CSV.new(file.read, csv_options)
    csv_file.each do |row|
      Device.create(
        timestamp: row['timestamp'],
        device_id: row['id'],
        device_type: row['type'],
        status: row['status']
      )
    end
  end

  def self.top_occurrences(timestamp)
    # This method returns an ARRAY of arrays! array[0][0] => (device_id)
    #                                         array[0][1] => (popularity)

    # I think im doing something wrong calling the
    # .first(10) last in the method chain
    Device.where(
      "timestamp >= ? AND timestamp <= ?",
      "#{timestamp} 00:00:00",
      "#{timestamp} 23:59:59"
    )
          .group(:device_id)
          .count.sort_by { |_key, value| value * -1 }
          .first(10)
  end
end

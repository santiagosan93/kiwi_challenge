require "csv"
class Device < ApplicationRecord
  validates :timestamp,       presence: true
  validates :device_id,       presence: true
  validates :device_type,     presence: true
  validates :status,          presence: true

  validates :device_type,     inclusion: { in: %w[gateway sensor] }
  validates :status,          inclusion: { in: %w[online offline] }

  private

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
    Device.where(
      "timestamp >= ? AND timestamp <= ?",
      "#{timestamp} 00:00:00",
      "#{timestamp} 23:59:59"
    )
  end
end

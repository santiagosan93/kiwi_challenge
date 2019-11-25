require 'csv'
class DevicesController < ApplicationController
  def new_csv; end

  def index
    if params[:device]
      p device_params[:timestamp].class
      @occurrences = Device.where(
        "timestamp >= ? AND timestamp <= ?",
        "#{device_params[:timestamp]} 00:00:00",
        "#{device_params[:timestamp]} 23:59:59"
      )
      p @occurrences.count
    end
  end

  def proces_csv
    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    csv_file = CSV.new(params[:csv_file].read, csv_options)
    csv_file.each do |row|
      Device.create(
        timestamp: row['timestamp'],
        device_id: row['id'],
        device_type: row['type'],
        status: row['status']
      )
    end
  end

  private

  def device_params
    params.require(:device).permit(:timestamp)
  end
end

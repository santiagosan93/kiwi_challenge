class DevicesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[proces_csv]
  before_action :authenticate_user!, only: %i[index]

  def index
    return unless params[:device]

    @day = device_params[:timestamp]
    @devices = Device.get_devices(@day)
  end

  def device_history
    return unless params[:device]

    @day = device_params[:timestamp]
    @type = device_params[:device_type]
    @status = device_params[:status]
    @all_days = get_all_days([], @day, @status, @type)
  end

  def proces_csv
    if authenticate_user_key
      Device.create_records(params[:X_Upload_File])
      render :proces_csv, status: :created
    else
      render :error, status: :unauthorized
    end
  end

  private

  def get_all_days(all_days, day, status, type)
    all_days = all_days
    counter = 0
    30.times do
      @device_count = Device.get_types((day.to_date + counter).to_s, type, status)
      all_days << [@device_count, (day.to_date + counter).to_s]
      counter -= 1
    end
    all_days
  end

  def authenticate_user_key
    user  = User.find_by(email: params[:X_User_Email])
    token = params[:X_User_Token]
    return user.authentication_token == token if user

    false
  end

  def device_params
    params.require(:device).permit(:timestamp, :device_type, :status)
  end
end

class DevicesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[proces_csv]
  # skip_before_action :authenticate_entity_from_token!, only: %i[proces_csv]
  # skip_before_action :authenticate_user!, only: %i[proces_csv]
  before_action :authenticate_user!, only: %i[index]

  # method created for testing
  # def new_csv; end

  def index
    if params[:device]
      @occurrences = Device.top_occurrences(device_params[:timestamp])
      p @occurrences.count
    end
  end

  def proces_csv
    if authenticate_user_key
      Device.create_records(params["report.csv"])
      render :proces_csv, status: :created
    else
      render :error, status: :unauthorized
    end
  end

  private

  def authenticate_user_key
    user  = User.find_by(email: params[:X_User_Email])
    token = params[:X_User_Token]
    return user.authentication_token == token if user

    false
  end

  def device_params
    params.require(:device).permit(:timestamp)
  end
end

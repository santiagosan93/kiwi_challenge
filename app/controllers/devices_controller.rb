class DevicesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[proces_csv]

  # Forces the user to log in and get the key for authenticity
  # when uploading a csv file
  before_action :authenticate_user!, only: %i[index]

  # method created for testing
  # def new_csv; end

  def index
    # I would prefere the use of if over return unless (rubocop)
    # Also the example doesn't have an empty line after return clause.
    return unless params[:device]

    @occurrences = Device.top_occurrences(device_params[:timestamp])
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

class DevicesController < ApplicationController
  # Could not do the authentication using normal device
  # So I made my own method to authenticate still using the
  # token generator by --> gem 'simple_token_authentication'
  # In order to make it work I have to disable normal authentication.
  skip_before_action :verify_authenticity_token, only: %i[proces_csv]

  # Forces the user to log in and get the key for authenticity
  # when uploading a csv file
  before_action :authenticate_user!, only: %i[index]

  # method created for testing
  # def new_csv; end

  def index
    # I would prefere the use of if over return unless (rubocop)
    # Also the example doesn't have an empty line after return clause,
    # but rubocop forces the empty line.
    return unless params[:device]

    @day = device_params[:timestamp]
    @occurrences = Device.top_occurrences(@day)
    @sample_ids = @occurrences.map { |key, _val| key }
    @prev_occurrances = Device.top_occurrences_with_ids((@day.to_date - 7).to_s, @sample_ids)
    @ordered_devices = Device.popular_devices(@day, @sample_ids)
    @counted_ordered_devices = @ordered_devices.map.with_index do |(device, _sorter), index|
      third_element = 0
      third_element = @prev_occurrances[index][1] if @prev_occurrances[index]
      [device, @occurrences[index][1], third_element]
    end
    raise
  end

  def proces_csv
    if authenticate_user_key
      Device.create_records(params[:X_Upload_File])
      render :proces_csv, status: :created
    else
      render :error, status: :unauthorized
    end
  end

  def device_history
    # Wait until email is responded to know what to do
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

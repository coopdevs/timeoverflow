class DeviceTokensController < ApplicationController
  before_filter :authenticate_user!

  def create
    @device_token = DeviceToken.new device_token_params.merge! user_id: current_user.id

    if @device_token.save
      render nothing: true, status: :created
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private

  def device_token_params
    params.permit(:token)
  end
end

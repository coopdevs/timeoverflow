class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :intercept_html_requests
  helper_method :current_user

  def intercept_html_requests
    if request.format == Mime::HTML and request.method == "GET"
      render "application/index"
    end
  end

  def index
    Rails.logger.warn request.headers
    Rails.logger.warn request.format
  end

  # rescue_from Exception do |exc|
  #   render json: {message: exc.message, type: exc.class.name}, status: 500
  # end

  private
  def current_user
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= User.first
  end
end

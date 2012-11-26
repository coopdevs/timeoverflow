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

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

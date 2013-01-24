class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :intercept_html_requests
  helper_method :current_user

  rescue_from CanCan::AccessDenied do |exception|
    head 401
  end

  def intercept_html_requests
    render "application/index" and return if request.format == Mime::HTML and request.method == "GET"
  end

  def index
    ap request.headers.reject { |k, v| /[a-z]/ === k }
    ap format: request.format
  end

  # rescue_from Exception do |exc|
  #   render json: {message: exc.message, type: exc.class.name}, status: 500
  # end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # @current_user ||= User.first
  end
end

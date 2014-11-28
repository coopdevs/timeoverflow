class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  protect_from_forgery
  helper :glyph

  helper_method :current_organization, :admin?, :superadmin?

  # before_filter do
  #   ap session.keys
  # end

  MissingTOSAcceptance = Class.new(Exception)
  OutadedTOSAcceptance = Class.new(Exception)

  before_filter :set_locale

  append_before_filter :check_for_terms_acceptance!, unless: :devise_controller?

  rescue_from MissingTOSAcceptance, OutadedTOSAcceptance do
    redirect_to terms_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

  def after_sign_in_path_for(user)
    if user.members.present?
      if user.members.any? &:manager
        users_path
      else
        offers_path
      end
    else
      page_path("home")
    end
  end

  private

  def check_for_terms_acceptance!
    accepted = current_user.terms_accepted_at
    if user_signed_in?
      if accepted.nil?
        raise MissingTOSAcceptance
      elsif accepted < Document.terms_and_conditions.updated_at
        raise OutadedTOSAcceptance
      end
    end
  end

  def current_organization
    @current_organization ||= current_user.try(:organizations).try(:first)
  end

  def admin?
    current_user.try :manages?, current_organization
  end

  def superadmin?
    current_user.try :superuser?
  end

  alias :superuser? :superadmin?

  def authenticate_superuser!
    superuser? || redirect_to(root_path)
  end

  # To get locate from client supplied information
  # see http://guides.rubyonrails.org/i18n.html#setting-the-locale-from-the-client-supplied-information
  def set_locale
    # read locale from params, the session or the Accept-Language header
    I18n.locale = params[:locale] ||
      session[:locale] ||
      http_accept_language.compatible_language_from(I18n.available_locales) ||
      I18n.default_locale
    # set in the session (so ppl can override what the browser sends)
    session[:locale] = I18n.locale
  end
end

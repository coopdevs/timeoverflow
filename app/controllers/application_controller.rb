class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :setup_vars

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

  def set_locale
    if params[:locale]
      locale = params[:locale]
      session[:locale] = locale
    else
      locale = extract_locale_from_accept_language_header rescue nil
    end

    # we check that provided locale from browser is in our supported list of languages
    # if not, we use the default from rails conf
    session[:locale] ||= @supported_langs.include?(locale)? locale: I18n.default_locale.to_s
    I18n.locale = session[:locale]
    true
  end

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
      page_path('home')
    end
  end

  def setup_vars
    @supported_langs=%w(es ca en)
  end

  private

  def check_for_terms_acceptance!
    if user_signed_in?
      if current_user.terms_accepted_at.nil?
        raise MissingTOSAcceptance
      elsif current_user.terms_accepted_at < Document.terms_and_conditions.updated_at
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
  #
  # TODO: Use  Rack::Locale  from  https://github.com/rack/rack-contrib
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end

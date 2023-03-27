class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  MissingTOSAcceptance = Class.new(Exception)
  OutadedTOSAcceptance = Class.new(Exception)

  append_before_action :check_for_terms_acceptance!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale,
                :set_current_organization,
                :store_user_location

  rescue_from MissingTOSAcceptance, OutadedTOSAcceptance do
    redirect_to terms_path
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  helper_method :current_organization, :admin?, :superadmin?

  def switch_lang
    redirect_back(fallback_location: root_path)
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def set_current_organization
    if org_id = session[:current_organization_id]
      @current_organization = Organization.find(org_id)
    elsif current_user
      @current_organization = current_user.organizations.first
    end
  end

  def store_user_location
    if request.get? && !request.xhr? && is_navigational_format? && !devise_controller?
      store_location_for(:user, request.fullpath)
    end
  end

  def after_sign_in_path_for(user)
    stored_location = stored_location_for(user)

    if stored_location.present?
      stored_location
    elsif user.members.present?
      users_path
    else
      page_path("about")
    end
  end

  def check_for_terms_acceptance!
    if user_signed_in?
      accepted = current_user.terms_accepted_at
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

  def current_member
    @current_member ||= current_user.as_member_of(current_organization) if current_user
  end

  def pundit_user
    current_member
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

  def options_locale
    current_user.try(:locale) ||
      session[:locale] ||
      http_accept_language.compatible_language_from(I18n.available_locales) ||
      I18n.default_locale
  end

  def set_locale
    I18n.locale =
      if params[:locale]
        current_user.update(locale: params[:locale]) if current_user
        params[:locale]
      else
        options_locale
      end

    session[:locale] = I18n.locale
  end

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def resource_not_found
    render 'errors/not_found', status: 404
  end

  def member_should_exist_and_be_active
    if !current_member
      redirect_to organizations_path
    elsif !current_member.active
      flash[:error] = I18n.t('users.index.account_deactivated')
      redirect_to select_organization_path
    end
  end

  def user_should_be_confirmed
    return if !current_user || current_user.confirmed?

    redirect_to please_confirm_users_path
  end
end

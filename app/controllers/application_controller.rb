class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :ensure_logged_in_user, unless: :devise_controller?
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_user_to_profile_page_if_incomplete_profile, unless: :devise_controller?
  before_action :disallow_inactive_users, unless: :devise_controller?

  private

  def ensure_logged_in_user
    redirect_to root_path and return unless current_user
  end

  def set_locale
    return unless current_user

    I18n.locale = current_user.locale
  end

  def configure_permitted_parameters
    added_attrs = [:name, :country_code, :locale]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  end

  def redirect_user_to_profile_page_if_incomplete_profile
    return unless current_user
    return if current_user.complete_profile_information? || on_user_profile_page?

    flash.notice = t('flash.user.complete_profile_to_continue')
    redirect_to user_path(current_user) and return
  end

  def on_user_profile_page?
    controller_name == 'users' && (action_name == 'show' || action_name == 'update')
  end

  def disallow_inactive_users
    render 'pages/not_authorized' and return if current_user&.inactive?
  end
end

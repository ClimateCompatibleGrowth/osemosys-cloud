class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :ensure_logged_in_user
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

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
end

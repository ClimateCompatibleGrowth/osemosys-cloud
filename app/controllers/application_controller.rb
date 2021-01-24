class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  private

  def ensure_logged_in_user
    redirect_to root_path and return unless current_user
  end

  def set_locale
    return unless current_user

    I18n.locale = current_user.locale
  end
end

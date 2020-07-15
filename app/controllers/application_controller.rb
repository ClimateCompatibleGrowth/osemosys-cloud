class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def ensure_logged_in_user
    redirect_to root_path and return unless current_user
  end
end

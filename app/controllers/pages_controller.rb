class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_logged_in_user

  def not_found
    respond_to do |format|
      format.html { render status: 404 }
    end
  end

  def home
    redirect_to models_path and return if current_user
  end

  def not_authorized; end
end

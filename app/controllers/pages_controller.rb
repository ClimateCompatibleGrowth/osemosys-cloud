class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def not_found; end

  def home
    redirect_to models_path and return if current_user
  end
end

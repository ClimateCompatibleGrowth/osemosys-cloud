class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    redirect_to models_path and return if current_user
  end
end

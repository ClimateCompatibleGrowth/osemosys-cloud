class PagesController < ApplicationController
  def home
    redirect_to runs_path and return if current_user
  end
end

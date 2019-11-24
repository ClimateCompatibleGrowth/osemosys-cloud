class UsersController < ApplicationController
  before_action :restrict_access_to_correct_user

  def show
    @user = current_user
  end

  private

  def restrict_access_to_correct_user
    redirect_to root_path and return unless current_user&.id == params[:id].to_i
  end
end

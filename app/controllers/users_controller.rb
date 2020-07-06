# typed: false
class UsersController < ApplicationController
  before_action :restrict_access_to_correct_user

  def show
    @user = current_user
  end

  def update
    current_user.update!(user_params)
    redirect_to action: :show
  end

  private

  def user_params
    params.require(:user).permit(:runs_visible_to_admins)
  end

  def restrict_access_to_correct_user
    redirect_to root_path and return unless current_user&.id == params[:id].to_i
  end
end

class UsersController < ApplicationController
  before_action :restrict_access_to_correct_user

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash.notice = t('users_controller.user_updated')
      redirect_to action: :show
    else
      flash.now.alert = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:runs_visible_to_admins, :locale)
  end

  def restrict_access_to_correct_user
    redirect_to root_path and return unless current_user&.id == params[:id].to_i
  end
end

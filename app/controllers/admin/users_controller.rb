module Admin
  class UsersController < AdminController
    def index
      @q = User.ransack(params[:q])
      @users = @q.result.includes(:runs).order(:id).page(params[:page]).per(50)
    end

    def show
      @user = User.find(params[:id])
      @run_count_by_state = @user.runs.group(:state).count
      @run_duration_by_state = @user.runs.group(:state).sum(:finished_in)
      @user_runs = @user.runs.order(id: :asc)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        flash.notice = t('flash.user.updated')
        redirect_to action: :show
      else
        flash.now.alert = @user.errors.full_messages.to_sentence
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :country_code,
        :locale,
        :name,
        :runs_visible_to_admins,
      )
    end
  end
end

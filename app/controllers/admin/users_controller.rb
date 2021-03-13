module Admin
  class UsersController < AdminController
    def index
      respond_to do |format|
        @q = User.ransack(params[:q])
        @q.sorts = 'id asc' if @q.sorts.empty?
        @users = @q.result.includes(:runs).page(params[:page]).per(50)

        format.html
        format.csv do
          send_data(
            UsersToCsv.new(@users.per(1000)).generate,
            filename: 'users.csv',
          )
        end
      end
    end

    def show
      @user = User.find(params[:id])
      @run_count_by_state = @user.runs.unscoped.group(:state).count
      @run_duration_by_state = @user.runs.unscoped.group(:state).sum(:finished_in)
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
        :active,
      )
    end
  end
end

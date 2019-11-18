module Admin
  class UserStatsController < AdminController
    def index
      @all_users = User.order(:id)
    end

    def show
      @user = User.find(params[:id])
    end
  end
end

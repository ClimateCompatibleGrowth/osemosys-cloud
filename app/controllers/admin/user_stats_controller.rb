module Admin
  class UserStatsController < AdminController
    def index
      @all_users = User.order(:id)
    end
  end
end

module Admin
  class StatsController < AdminController
    def index
      @all_users = User.order(:id)
    end
  end
end

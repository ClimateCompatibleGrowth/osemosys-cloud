module Admin
  class UsersController < AdminController
    def index
      @all_users = User.order(:id)
    end
  end
end

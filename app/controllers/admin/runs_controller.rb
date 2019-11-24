module Admin
  class RunsController < AdminController
    def index
      @user = User.find(params[:user_id])
      @runs = @user.runs
    end
  end
end

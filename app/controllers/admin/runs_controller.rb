module Admin
  class RunsController < AdminController
    def index
      @user = User.find(params[:user_id])
      @runs = @user.runs.kept.for_index_view(params[:page])
    end
  end
end

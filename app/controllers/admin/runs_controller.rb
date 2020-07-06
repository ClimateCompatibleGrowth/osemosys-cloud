module Admin
  class RunsController < AdminController
    def index
      @user = User.find(params[:user_id])
      @runs = @user.runs
        .order(id: :desc)
        .page(params[:page])
        .with_attached_model_file
        .with_attached_data_file
        .with_attached_log_file
    end
  end
end

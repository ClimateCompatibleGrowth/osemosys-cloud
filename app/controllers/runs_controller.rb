class RunsController < ApplicationController
  before_action :ensure_logged_in_user

  def new
    @run = Run.new(version_id: params[:version_id])
  end

  def show
    head :not_found unless request.xhr?

    @run =
      if current_user.admin?
        Run.find(params[:id])
      else
        current_user.runs.find_by(id: params[:id])
      end
  end

  def create
    @run = current_user.runs.create(run_params)

    if @run.valid?
      flash.notice = 'Run created'
      redirect_to version_path(@run.version)
    else
      flash.now.alert = @run.errors.full_messages.to_sentence
      render :new
    end
  end

  def start
    run = Run.find(params[:id])
    if run.transition_to!(:queued)
      SolveRunJob.perform_later(
        run_id: run.id,
      )
    end
    flash.notice = 'Run started'
    redirect_to version_path(run.version)
  end

  def stop
    run = Run.find(params[:id])
    Ec2::StopInstance.call(aws_id: run.ec2_instance.aws_id)
    flash.notice = 'Run stopped'
    redirect_to version_path(run.version)
  end

  private

  def run_params
    params.require(:run).permit(
      :name, :model_file, :data_file, :description, :pre_process, :post_process,
      :notify_when_finished, :version_id, :server_type
    )
  end

  def ensure_logged_in_user
    redirect_to root_path and return unless current_user
  end
end

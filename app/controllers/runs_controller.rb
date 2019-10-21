class RunsController < ApplicationController
  before_action :ensure_logged_in_user

  def new
    @run = Run.new
  end

  def index
    @runs = current_user.runs
      .order(id: :desc)
      .page(params[:page])
      .with_attached_model_file
      .with_attached_data_file
      .with_attached_result_file
      .with_attached_log_file
  end

  def create
    @run = current_user.runs.create(run_params)

    if @run.valid?
      flash.notice = 'Run created'
      redirect_to runs_path
    else
      flash.now.alert = @run.errors.full_messages.to_sentence
      render :new
    end
  end

  def start
    run = Run.find(params[:id])
    SolveRunJob.perform_later(
      run_id: run.id,
    )
    run.transition_to!(:queued)
    flash.notice = 'Run started'
    redirect_to action: :index
  end

  def stop
    run = Run.find(params[:id])
    Ec2::StopInstance.call(aws_id: run.ec2_instance.aws_id)
    flash.notice = 'Run stopped'
    redirect_to action: :index
  end

  private

  def run_params
    params.require(:run).permit(:name, :model_file, :data_file, :description, :pre_process)
  end

  def ensure_logged_in_user
    redirect_to root_path and return unless current_user
  end
end

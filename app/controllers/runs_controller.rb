class RunsController < ApplicationController
  before_action :ensure_logged_in_user

  def new
    @run = Run.new
  end

  def index
    @runs = current_user.runs
                        .order(id: :desc)
                        .with_attached_model_file
                        .with_attached_data_file
                        .with_attached_result_file
                        .with_attached_log_file
  end

  def create
    current_user.runs.create!(run_params)
    flash.notice = 'Run created'
    redirect_to runs_path
  end

  def start
    run = Run.find(params[:id])
    Osemosys::Ec2Instance.new(run_id: run.id).spawn! if run_on_ec2?
    run.update_attributes(queued_at: Time.current)
    flash.notice = 'Run started'
    redirect_to action: :index
  end

  private

  def run_params
    params.require(:run).permit(:name, :model_file, :data_file, :description)
  end

  def run_on_ec2?
    return true if Rails.env.production?
    false
  end

  def ensure_logged_in_user
    redirect_to root_path and return unless current_user
  end
end

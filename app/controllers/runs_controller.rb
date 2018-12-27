class RunsController < ApplicationController
  def new
    @run = Run.new
  end

  def index
    @runs = Run.order(:id)
  end

  def create
    Run.create!(run_params)
    redirect_to runs_path
  end

  def start
    run = Run.find(params[:id])
    Osemosys::Ec2Instance.new(run_id: run.id).spawn!
    run.update_attributes(queued_at: Time.current)
    redirect_to action: :index
  end

  private

  def run_params
    params.require(:run).permit(:name, :model_file, :data_file)
  end
end

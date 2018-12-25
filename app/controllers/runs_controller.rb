class RunsController < ApplicationController
  def new
    @run = Run.new
  end

  def index
    @runs = Run.all
  end

  def create
    Run.create!(run_params)
    redirect_to runs_path
  end

  private

  def run_params
    params.require(:run).permit(:name)
  end
end

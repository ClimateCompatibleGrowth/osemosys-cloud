class EnqueueRunSolverJob < ApplicationJob
  def perform(run_id:)
    @run = Run.find(run_id)

    if run_on_ec2?
      spawn_ec2_instance
    else
      enqueue_solve_run_job
    end
  end

  private

  attr_reader :run

  def run_on_ec2?
    Rails.env.production? && run.ec2?
  end

  def spawn_ec2_instance
    Ec2::CreateInstance.call(
      run_id: run.id,
      instance_type: run.server_type,
    )
  end

  def enqueue_solve_run_job
    SolveRunJob.perform_later(run_id: run.id)
  end
end

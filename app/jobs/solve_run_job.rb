class SolveRunJob < ActiveJob::Base
  sidekiq_options retry: 0

  def perform(run_id:)
    @run = Run.find(run_id)

    if run_on_ec2?
      spawn_ec2_instance
    else
      run_inline
    end
  end

  private

  attr_reader :run

  def run_on_ec2?
    Rails.env.production? && run.server_type != 'sidekiq'
  end

  def spawn_ec2_instance
    Ec2::CreateInstance.call(
      run_id: run.id,
      instance_type: run.server_type,
    )
  end

  def run_inline
    SolveRun.new(
      run: run,
      solver: Osemosys::Solvers::Cbc,
    ).call
  end
end

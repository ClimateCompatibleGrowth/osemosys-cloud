class SolveRunJob < ActiveJob::Base
  sidekiq_options retry: 0

  def perform(run_id:, instance_type: 'z1d.3xlarge')
    @run_id = run_id
    @instance_type = instance_type

    if run_on_ec2?
      spawn_ec2_instance
    else
      run_inline
    end
  end

  private

  attr_reader :run_id, :instance_type

  def run_on_ec2?
    Rails.env.production?
  end

  def spawn_ec2_instance
    Ec2::CreateInstance.call(
      run_id: run_id,
      instance_type: instance_type,
    )
  end

  def run_inline
    SolveRun.new(
      run: Run.find(run_id),
      solver: Osemosys::Solvers::Cbc,
    ).call
  end
end

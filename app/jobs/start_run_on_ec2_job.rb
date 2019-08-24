class StartRunOnEc2Job < ActiveJob::Base
  def perform(run_id:, instance_type: 'z1d.3xlarge')

    if run_on_ec2?
      Ec2::Instance.new(
        run_id: run_id,
        instance_type: instance_type,
      ).spawn!
    else
      SolveRun.new(
        run: Run.find(run_id),
        solver: Osemosys::Solvers::Cbc,
      ).call
    end
  end

  private

  def run_on_ec2?
    Rails.env.production?
  end
end

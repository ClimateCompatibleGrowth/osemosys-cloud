class StartRunOnEc2Job < ActiveJob::Base
  def perform(run_id:, instance_type: 'z1d.3xlarge')
    return unless run_on_ec2?

    Osemosys::Ec2Instance.new(
      run_id: run_id,
      instance_type: instance_type,
    ).spawn!
  end

  private

  def run_on_ec2?
    return true if Rails.env.production?

    false
  end
end

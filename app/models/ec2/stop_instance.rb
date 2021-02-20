module Ec2
  class StopInstance
    def self.call(**args)
      new(**args).call
    end

    def initialize(aws_id:)
      @aws_id = aws_id
    end

    def call
      terminate_instance
      set_run_as_failed
      set_instance_stopped_at
    end

    private

    attr_reader :aws_id

    def terminate_instance
      resource.instance(aws_id).terminate
    end

    def set_run_as_failed
      ec2_instance.run.transition_to!(:failed)
    end

    def set_instance_stopped_at
      ec2_instance.update!(stopped_at: Time.current)
    end

    def ec2_instance
      @ec2_instance ||= Ec2::Instance.find_by(aws_id: aws_id)
    end

    def resource
      @resource ||= Aws::EC2::Resource.new(region: 'eu-west-1')
    end
  end
end

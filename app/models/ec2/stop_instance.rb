module Ec2
  class StopInstance
    def self.call(*args)
      new(*args).call
    end

    def initialize(aws_id:)
      @aws_id = aws_id
    end

    def call
      terminate_instance
      set_run_as_failed
    end

    private

    attr_reader :aws_id

    def terminate_instance
      resource.instance(aws_id).terminate
    end

    def set_run_as_failed
      Ec2::Instance.find_by(aws_id: aws_id).run.transition_to!(:failed)
    end

    def resource
      @resource ||= Aws::EC2::Resource.new(region: 'eu-west-1')
    end
  end
end

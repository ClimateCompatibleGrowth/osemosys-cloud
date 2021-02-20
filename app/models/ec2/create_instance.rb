module Ec2
  class CreateInstance
    def self.call(**args)
      new(**args).call
    end

    def initialize(run_id:, instance_type:)
      @run_id = run_id
      @instance_type = instance_type
    end

    def call
      spawn_instance

      instance = Instance.create!(
        run_id: run_id,
        started_at: Time.current,
      )

      wait_until_running

      instance.update!(
        ip: spawned_instance.public_ip_address,
        instance_type: instance_type,
        aws_id: spawned_instance.id,
      )
    end

    private

    def instance_params
      InstanceParams.new(
        instance_type: instance_type,
        run_id: run_id,
      ).to_h
    end

    attr_reader :run_id, :instance_type

    def spawn_instance
      @instances = resource.create_instances(instance_params)
    end

    def wait_until_running
      resource.client.wait_until(
        :instance_running, instance_ids: [@instances.first.id]
      )
    end

    def spawned_instance
      return unless @instances

      @spawned_instance ||= @instances.first.load
    end

    def resource
      @resource ||= Aws::EC2::Resource.new(region: 'eu-west-1')
    end
  end
end

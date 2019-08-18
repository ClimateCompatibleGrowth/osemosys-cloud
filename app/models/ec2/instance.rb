module Ec2
  class Instance
    def initialize(run_id:, instance_type:)
      @run_id = run_id
      @instance_type = instance_type
    end

    def spawn!
      create!

      wait_until_running
      puts instance.public_ip_address
      instance
    end

    def instance_params
      InstanceParams.new(
        instance_type: instance_type,
        run_id: run_id,
      ).to_h
    end

    private

    attr_reader :run_id, :instance_type

    def create!
      logger.info 'Creating instance'
      @instances = resource.create_instances(instance_params)
    end

    def wait_until_running
      logger.info 'Waiting for the instance to start'
      resource.client.wait_until(
        :instance_running, instance_ids: [@instances.first.id]
      )
    end

    def instance
      return unless @instances

      @instances.first.load
    end

    def resource
      @resource ||= Aws::EC2::Resource.new(region: 'eu-west-1')
    end

    def logger
      Osemosys::Config.logger
    end
  end
end

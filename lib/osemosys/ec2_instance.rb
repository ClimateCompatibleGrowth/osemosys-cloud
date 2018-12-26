module Osemosys
  class Ec2Instance
    def spawn!
      create!
      wait_until_running
      instance
    end

    private

    def create!
      logger.info 'Creating instance'
      @instances = resource.create_instances(
        image_id: 'ami-0b076da55f7be4124', # Osemosys Cloud - GLPK
        min_count: 1,
        max_count: 1,
        key_name: 'aws-perso',
        security_group_ids: ['sg-234d125d'],
        instance_type: 't2.micro',
        iam_instance_profile: {
          name: 'Osemosys'
        },
        instance_initiated_shutdown_behavior: 'terminate'
      )
    end

    def block_instance_store_settings
      # Used when creating a new image from scratch
      {
        image_id: 'ami-09693313102a30b2c', # Linux 2 AMI
        block_device_mappings: [
          {
            device_name: '/dev/xvda',
            ebs: {
              delete_on_termination: true,
              volume_size: 12
            }
          }
        ]
      }
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
      Config.logger
    end
  end
end

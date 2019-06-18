module Osemosys
  class Ec2Instance
    def initialize(run_id:, async: true, instance_type: 't2.micro')
      @run_id = run_id
      @instance_type = instance_type
      @async = async
    end

    def spawn!
      # return if Rails.env.development?
      create!
      return if async
      wait_until_running
      puts instance.public_ip_address
      instance
    end

    def instance_params
      params = base_params
      if supports_cpu_options?
        params.merge(cpu_options)
      else
        params
      end
    end

    private

    attr_reader :run_id, :async, :instance_type

    def create!
      logger.info 'Creating instance'
      @instances = resource.create_instances(instance_params)
    end

    def base_params
      {
        image_id: 'ami-01a4b18debb890d7d', # Osemosys-Docker
        min_count: 1,
        max_count: 1,
        key_name: 'aws-perso',
        user_data: encoded_user_data,
        security_group_ids: ['sg-234d125d'],
        instance_type: instance_type,
        iam_instance_profile: {
          name: 'Osemosys'
        },
        instance_initiated_shutdown_behavior: 'terminate'
      }
    end

    def cpu_options
      {
        cpu_options: {
          core_count: 2,
          threads_per_core: 1
        }
      }
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

    def encoded_user_data
      Base64.encode64(user_data)
    end

    def user_data
      "#!/usr/bin/env bash\n"\
      "su - ec2-user -c '#{solve_run_command}'"
    end

    def solve_run_command
      shutdown_on_finish = true

      "curl https://raw.githubusercontent.com/yboulkaid/osemosys-cloud/master/lib/solver/user_data.sh | sh -s #{run_id} #{shutdown_on_finish}"
    end

    def supports_cpu_options?
      instance_type == 'c5.xlarge' || instance_type == 'c5.9xlarge'
    end

    def logger
      Config.logger
    end
  end
end

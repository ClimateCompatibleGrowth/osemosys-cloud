module Ec2
  class InstanceParams
    def initialize(instance_type:, run_id:)
      @instance_type = instance_type
      @run_id = run_id
    end

    def to_h
      if supports_cpu_options?
        base_params.merge(cpu_options)
      else
        base_params
      end
    end

    private

    attr_reader :instance_type, :run_id

    def base_params
      {
        image_id: 'ami-0942ea792bd48e31b', # Osemosys-Docker-new-db
        min_count: 1,
        max_count: 1,
        key_name: 'yboulkaid-osemosys',
        user_data: encoded_user_data,
        security_group_ids: ['sg-43911f25'],
        instance_type: instance_type,
        iam_instance_profile: {
          name: 'OsemosysEC2Role',
        },
        instance_initiated_shutdown_behavior: 'terminate',
      }
    end

    def cpu_options
      {
        cpu_options: {
          core_count: 2,
          threads_per_core: 1,
        },
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
              volume_size: 12,
            },
          },
        ],
      }
    end

    def supports_cpu_options?
      instance_type == 'z1d.3xlarge' || instance_type == 'c5.9xlarge'
    end

    def encoded_user_data
      UserData.new(run_id: run_id).to_base64_encoded
    end
  end
end

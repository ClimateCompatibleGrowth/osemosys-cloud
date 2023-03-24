module Ec2
  class UserData
    def initialize(shutdown_on_finish: true, run_id:)
      @shutdown_on_finish = shutdown_on_finish
      @run_id = run_id
    end

    def to_base64_encoded
      Base64.encode64(user_data)
    end

    private

    attr_reader :shutdown_on_finish, :run_id

    def user_data
      <<~BASH
        #!/bin/bash
        su - ubuntu -c '#{solve_run_command}'
      BASH
    end

    def solve_run_command
      %(
        cd /home/ubuntu/osemosys-cloud/
        && git pull || true
        && bin/deploy_and_solve_run.sh #{run_id} #{shutdown_on_finish}
      ).delete("\n")
    end
  end
end

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
      "#!/usr/bin/env bash\n"\
      "su - ubuntu -c '#{solve_run_command}'"
    end

    def solve_run_command
      "/home/ubuntu/osemosys-cloud/bin/deploy_and_solve_run.sh #{run_id} #{shutdown_on_finish}"
    end
  end
end

module Osemosys
  class Ec2UserData
    def initialize(shutdown_on_finish: true)
      @shutdown_on_finish = shutdown_on_finish
    end

    def to_base64_encoded
      Base64.encode64(user_data)
    end

    private

    attr_reader :shutdown_on_finish

    def user_data
      "#!/usr/bin/env bash\n"\
      "su - ec2-user -c '#{solve_run_command}'"
    end

    def solve_run_command
      "curl https://raw.githubusercontent.com/yboulkaid/osemosys-cloud/master/lib/solver/user_data.sh | sh -s #{run_id} #{shutdown_on_finish}"
    end

  end
end

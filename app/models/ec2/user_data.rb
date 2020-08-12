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
      "su - ec2-user -c '#{solve_run_command}'"
    end

    def solve_run_command
      "curl https://gist.githubusercontent.com/yboulkaid/4df07a12a050a8f8470bdcf30470e077/raw/91504c0d7b30226032017feef740b4b5f31a7f55/ec2_osemosys_user_data.sh | sh -s #{run_id} #{shutdown_on_finish}"
    end
  end
end

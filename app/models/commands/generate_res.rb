module Commands
  class GenerateRes
    def initialize(local_data_path:, res_path:, logger:)
      @local_data_path = local_data_path
      @res_path = res_path
      @logger = logger
    end

    def call
      logger.info 'Generating RES file'
      tty_command.run(generate_res_command)
    end

    def generate_res_command
      %(
        python3 #{Rails.root.join('scripts/osemosys_res/osemosys_RES.py')}
              #{local_data_path}
              #{res_path}
      ).delete("\n")
    end

    private

    attr_reader :local_data_path, :res_path, :logger

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end
  end
end

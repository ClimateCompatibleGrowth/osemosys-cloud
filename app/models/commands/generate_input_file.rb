module Commands
  class GenerateInputFile
    def initialize(local_model_path:, local_data_path:, lp_path:, logger:, timeout:)
      @local_model_path = local_model_path
      @local_data_path = local_data_path
      @lp_path = lp_path
      @logger = logger
      @timeout = timeout
    end

    def call
      logger.info 'Generating input file'
      tty_command.run(glpsol_command)
    end

    private

    attr_reader :local_model_path, :local_data_path, :lp_path, :logger, :timeout

    def glpsol_command
      %(
      timeout #{timeout} glpsol -m #{local_model_path}
             -d #{local_data_path}
             --wlp #{lp_path}
             --check
      ).delete("\n")
    end

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end
  end
end

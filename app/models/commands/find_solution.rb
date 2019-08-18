module Commands
  class FindSolution
    def initialize(lp_path:, output_path:, logger: Config.logger)
      @lp_path = lp_path
      @output_path = output_path
      @logger = logger
    end

    def call
      logger.info 'Solving the model'
      tty_command.run(cbc_command)
    end

    def cbc_command
      %(
        cbc #{lp_path} solve solu #{output_path}
      )
    end

    private

    attr_reader :lp_path, :output_path, :logger

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end
  end
end

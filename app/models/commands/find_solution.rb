module Commands
  class FindSolution
    def initialize(lp_path:, output_path:, logger:, timeout:)
      @lp_path = lp_path
      @output_path = output_path
      @logger = logger
      @timeout = timeout
    end

    def call
      logger.info 'Solving the model'
      tty_command.run(cbc_command)
    end

    def cbc_command
      %(
        timeout #{timeout} cbc #{lp_path} solve solu #{output_path}
      )
    end

    private

    attr_reader :lp_path, :output_path, :logger, :timeout

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end
  end
end

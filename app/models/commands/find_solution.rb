module Commands
  class FindSolution
    def initialize(lp_path:, output_path:)
      @lp_path = lp_path
      @output_path = output_path
    end

    def call
      Osemosys::Config.logger.info 'Solving the model'
      tty_command.run(cbc_command)
    end

    def cbc_command
      %(
        LD_LIBRARY_PATH=/app/.apt/usr/lib/x86_64-linux-gnu/blas:/app/.apt/usr/lib/x86_64-linux-gnu/lapack:$LD_LIBRARY_PATH \
        cbc #{lp_path} solve solu #{output_path}
      )
    end

    private

    attr_reader :lp_path, :output_path

    def tty_command
      @tty_command ||= TTY::Command.new(output: Osemosys::Config.logger, color: false)
    end
  end
end

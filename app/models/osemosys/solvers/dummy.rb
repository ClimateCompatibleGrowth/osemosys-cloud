module Osemosys
  module Solvers
    class Dummy
      def initialize(local_model_path:, local_data_path:, logger: Config.logger)
        @local_data_path = local_data_path
        @local_model_path = local_model_path
        @logger = logger
      end

      def call
        raise dummy_tty_exit_error if faulty_model?

        '/dev/null'
      end

      private

      def faulty_model?
        File.open(@local_data_path).size.zero?
      end

      def dummy_tty_exit_error
        TTY::Command::ExitError.new(
          'dummy_command', TTY::Command::Result.new(nil, nil, nil, nil)
        )
      end
    end
  end
end

module Osemosys
  module Solvers
    class Dummy
      def initialize(local_model_path:, local_data_path:, logger: Config.logger, run:, sleep_duration: 0)
        @local_data_path = local_data_path
        @run = run
        @sleep_duration = sleep_duration
      end

      def call
        raise dummy_tty_exit_error if faulty_model?
        sleep sleep_duration

        run.transition_to!(:generating_matrix)
        run.transition_to!(:finding_solution)
        '/dev/null'
      end

      private

      attr_reader :run, :sleep_duration, :local_data_path

      def faulty_model?
        File.open(local_data_path).size.zero?
      end

      def dummy_tty_exit_error
        TTY::Command::ExitError.new(
          'dummy_command', TTY::Command::Result.new(nil, nil, nil, nil)
        )
      end
    end
  end
end

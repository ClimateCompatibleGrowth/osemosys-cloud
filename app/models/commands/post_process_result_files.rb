module Commands
  class PostProcessResultFiles
    def initialize(preprocessed_data_path:, solution_file_path:)
      @preprocessed_data_path = preprocessed_data_path
      @solution_file_path = solution_file_path
    end

    def call
      Osemosys::Config.logger.info 'Postprocessing result file'
      tty_command.run(postprocessing_command)
    end

    private

    attr_reader :preprocessed_data_path, :solution_file_path

    def postprocessing_command
      %(
      python3 #{Rails.root.join('scripts/postprocess_results.py')}
              #{preprocessed_data_path}
              #{solution_file_path}
      ).delete("\n")
    end

    def tty_command
      @tty_command ||= TTY::Command.new(output: Osemosys::Config.logger, color: false)
    end
  end
end


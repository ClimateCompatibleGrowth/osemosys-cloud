module Commands
  class GenerateFigures
    def initialize(csv_path:, language:, logger:)
      @csv_path = csv_path
      @language = language
      @logger = logger
    end

    def call
      logger.info 'Postprocessing result file'
      tty_command.run(postprocessing_command)
    end

    private

    attr_reader :csv_path, :language, :logger

    def postprocessing_command
      %(
      python3 #{Rails.root.join('scripts/figure_generation/generate_figures.py')}
              #{csv_path}
              #{language}
      ).delete("\n")
    end

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end
  end
end

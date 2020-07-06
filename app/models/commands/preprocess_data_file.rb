module Commands
  class PreprocessDataFile
    def initialize(local_data_path:, preprocessed_data_path:)
      @local_data_path = local_data_path
      @preprocessed_data_path = preprocessed_data_path
    end

    def call
      Osemosys::Config.logger.info 'Preprocessing data file'
      tty_command.run(preprocessing_command)
    end

    private

    attr_reader :preprocessed_data_path, :local_data_path

    def preprocessing_command
      %(
      python3 #{Rails.root.join('scripts/preprocess_data.py')}
              #{local_data_path}
              #{preprocessed_data_path}
      ).delete("\n")
    end

    def tty_command
      @tty_command ||= TTY::Command.new(output: Osemosys::Config.logger, color: false)
    end
  end
end


module Commands
  class PreprocessDataFile
    def initialize(
      local_data_path:,
      preprocessed_data_path:,
      model_file_path:,
      preprocessed_model_file_path:,
      logger:
    )
      @local_data_path = local_data_path
      @preprocessed_data_path = preprocessed_data_path
      @model_file_path = model_file_path
      @preprocessed_model_file_path = preprocessed_model_file_path
      @logger = logger
    end

    def call
      logger.info 'Preprocessing data file'
      tty_command.run(preprocessing_command)
    end

    private

    attr_reader(
      :preprocessed_data_path,
      :model_file_path,
      :preprocessed_model_file_path,
      :local_data_path,
      :logger,
    )

    def preprocessing_command
      %(
      python3 #{Rails.root.join('scripts/preprocess_data.py')}
              #{local_data_path}
              #{preprocessed_data_path}
              #{model_file_path}
              #{preprocessed_model_file_path}
      ).delete("\n")
    end

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end
  end
end

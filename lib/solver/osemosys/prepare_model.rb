module Osemosys
  class PrepareModel
    def initialize(model_path:, data_path:)
      @model_path = model_path
      @data_path = data_path
    end

    def call
      upload_model_file
      upload_data_file
      logger.info file_paths
      print_summary
      file_paths
    end

    private

    attr_reader :model_path, :data_path

    def upload_model_file
      logger.info 'Uploading the model file...'
      model_file.upload_to_s3!
    end

    def upload_data_file
      logger.info 'Uploading the data file...'
      data_file.upload_to_s3!
    end

    def print_summary
      logger.info 'Model files uploaded to S3!'
      logger.info file_paths
      logger.info "run_id: #{Config.run_id}"
    end

    def file_paths
      {
        model_file: model_file.key,
        data_file: data_file.key
      }
    end

    def model_file
      ModelFile.new(model_path)
    end

    def data_file
      DataFile.new(data_path)
    end

    def logger
      Config.logger
    end
  end
end

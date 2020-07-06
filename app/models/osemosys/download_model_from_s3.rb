# typed: false
module Osemosys
  class DownloadModelFromS3
    def initialize(s3_data_key:, s3_model_key:, logger: Config.logger)
      @s3_model_key = s3_model_key
      @s3_data_key = s3_data_key
      @logger = logger
    end

    def call
      logger.info 'Downloading input files...'

      logger.info 'Downloading model file...'
      s3_model_object.download_file(local_model_file_path)

      logger.info 'Downloading data file...'
      s3_data_object.download_file(local_data_file_path)

      OpenStruct.new(
        local_model_path: local_model_file_path,
        local_data_path: local_data_file_path,
      )
    end

    private

    attr_reader :s3_model_key, :s3_data_key, :logger

    def s3_data_object
      @s3_data_object ||= s3.bucket(bucket).object(s3_data_key)
    end

    def s3_model_object
      @s3_model_object ||= s3.bucket(bucket).object(s3_model_key)
    end

    def local_data_file_path
      "/tmp/data_#{Config.run_id}.txt"
    end

    def local_model_file_path
      "/tmp/model_#{Config.run_id}.txt"
    end

    def bucket
      Config.s3_bucket
    end

    def s3
      @s3 ||= Aws::S3::Resource.new(region: 'eu-west-1')
    end
  end
end

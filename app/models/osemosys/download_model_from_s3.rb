module Osemosys
  class DownloadModelFromS3
    def initialize(run:, logger:)
      @run = run
      @logger = logger
    end

    def call
      raise if Rails.env.test?

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

    attr_reader :run, :logger

    def s3_data_key
      run.data_file.key
    end

    def s3_model_key
      run.model_file.key
    end

    def s3_data_object
      @s3_data_object ||= s3.bucket(bucket).object(s3_data_key)
    end

    def s3_model_object
      @s3_model_object ||= s3.bucket(bucket).object(s3_model_key)
    end

    def local_data_file_path
      "/tmp/data_#{run.id}.txt"
    end

    def local_model_file_path
      "/tmp/model_#{run.id}.txt"
    end

    def bucket
      Config.s3_bucket
    end

    def s3
      @s3 ||= Aws::S3::Resource.new(region: 'eu-west-1')
    end
  end
end

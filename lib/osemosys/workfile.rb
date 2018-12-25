module Osemosys
  class Workfile
    def initialize(path)
      @path = path
    end

    def upload_to_s3!
      return if @uploaded
      logger.info "Uploading #{basename} to #{full_key}..."
      @uploaded = s3_object.upload_file(file)
    end

    # def presigned_url
    #   return unless @uploaded
    #   s3_object.presigned_url(:get, expires_in: 3600)
    # end

    def key
      s3_object.key
    end

    private

    attr_reader :path

    def full_key
      "#{bucket}/#{s3_object.key}"
    end

    def file
      @file ||= File.open(path)
    end

    def basename
      File.basename(path)
    end

    def s3_object
      @s3_object ||= s3.bucket(bucket).object(s3_object_name)
    end

    def s3
      @s3 ||= Aws::S3::Resource.new(region: 'eu-west-1')
    end

    def bucket
      Config.s3_bucket
    end

    def s3_object_name
      # better name for io?
      "ruby_trial/#{run_id}/#{io}/#{type}/#{basename}"
    end

    def run_id
      Config.run_id
    end

    def logger
      Config.logger
    end
  end
end

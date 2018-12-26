module Osemosys
  class SolveModel
    def initialize(s3_data_key:, s3_model_key:, logger: Config.logger)
      @s3_model_key = s3_model_key
      @s3_data_key = s3_data_key
      @logger = logger
    end

    def call
      # TODO: save logs
      download_files_from_s3
      solve_model
      gzip_output
      print_summary
      output_file.file
    end

    private

    attr_reader :s3_model_key, :s3_data_key, :logger

    def download_files_from_s3
      logger.info 'Downloading input files...'

      logger.info 'Downloading model file...'
      s3_model_object.download_file(local_model_file_path)

      logger.info 'Downloading data file...'
      s3_data_object.download_file(local_data_file_path)
    end

    def solve_model
      logger.info 'Solving the model'
      tty_command.run(glpsol_command)
    end

    def gzip_output
      logger.info 'Gzipping the output'
      tty_command.run(gzip_command)
    end

    def print_summary
      logger.info 'Model solved!'
      logger.info ''
      logger.info "run_id: #{Config.run_id}"
    end

    def glpsol_command
      %(
      glpsol -m #{local_model_file_path}
             -d #{local_data_file_path}
             -o #{output_path}
      ).delete("\n")
    end

    def gzip_command
      "gzip -f #{output_path}"
    end

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end

    def s3_data_object
      @s3_data_object ||= s3.bucket(bucket).object(s3_data_key)
    end

    def s3_model_object
      @s3_model_object ||= s3.bucket(bucket).object(s3_model_key)
    end

    # TODO: Extract these
    def local_data_file_path
      "/tmp/data_#{Config.run_id}.txt"
    end

    def local_model_file_path
      "/tmp/model_#{Config.run_id}.txt"
    end

    def output_path
      './output.txt'
    end

    def gzipped_output_path
      './output.txt.gz'
    end

    def output_file
      OutputFile.new(gzipped_output_path)
    end

    def bucket
      Config.s3_bucket
    end

    def s3
      @s3 ||= Aws::S3::Resource.new(region: 'eu-west-1')
    end
  end
end

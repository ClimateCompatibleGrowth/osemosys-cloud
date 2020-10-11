module Osemosys
  class PrepareResults
    def self.call(*args)
      new(*args).call
    end

    def initialize(output_path:, data_path:, metadata_path:, destination:, logger:)
      @output_path = output_path
      @data_path = data_path
      @metadata_path = metadata_path
      @destination = destination
      @logger = logger
    end

    def call
      copy_files_to_temp_folder
      zip_output
    end

    private

    attr_reader :output_path, :data_path, :metadata_path, :destination, :logger

    def zip_output
      Commands::Zip.new(
        source: files_to_zip,
        destination: destination,
        logger: logger,
      ).call
    end

    def copy_files_to_temp_folder
      `mkdir #{tmp_folder}`
      `cp #{output_path} #{tmp_folder}/result.txt`
      `cp #{data_path} #{tmp_folder}/data.txt`
      `cp #{metadata_path} #{tmp_folder}/metadata.json`
    end

    def files_to_zip
      "#{tmp_folder}/result.txt #{tmp_folder}/data.txt #{tmp_folder}/metadata.json"
    end

    def tmp_folder
      @tmp_folder ||= "/tmp/#{rand(10_000)}"
    end
  end
end

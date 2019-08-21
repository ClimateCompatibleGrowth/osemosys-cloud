module Osemosys
  class SolveCbcModel
    def initialize(local_model_path:, local_data_path:, logger: Config.logger)
      @local_data_path = local_data_path
      @local_model_path = local_model_path
      @logger = logger
    end

    def call
      generate_input_file
      find_solution
      zip_output
      print_summary

      zipped_output_path
    end

    private

    attr_reader :local_data_path, :local_model_path, :logger

    def generate_input_file
      Commands::GenerateInputFile.new(
        local_model_path: local_model_path,
        local_data_path: local_data_path,
        lp_path: lp_path,
        logger: logger,
      ).call
    end

    def find_solution
      Commands::FindSolution.new(
        lp_path: lp_path,
        output_path: output_path,
        logger: logger,
      ).call
    end

    def zip_output
      Commands::Zip.new(
        source: output_path,
        destination: zipped_output_path,
        logger: logger,
      ).call
    end

    def print_summary
      logger.info 'Model solved!'
      logger.info ''
      logger.info "run_id: #{Config.run_id}"
    end

    def lp_path
      './data/input.lp'
    end

    def output_path
      './data/output.txt'
    end

    def zipped_output_path
      './data/output.zip'
    end
  end
end

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
      gzip_output
      print_summary

      gzipped_output_path
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

    def gzip_output
      Commands::Gzip.new(
        source: output_path,
        destination: gzipped_output_path,
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
      './data/output.sol'
    end

    def gzipped_output_path
      './data/output.sol.gz'
    end
  end
end

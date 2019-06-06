module Osemosys
  class SolveCbcModel
    def initialize(local_model_path:, local_data_path:, logger: Config.logger)
      @local_data_path = local_data_path
      @local_model_path = local_model_path
      @logger = logger
    end

    def call
      generate_input_file
      solve_model
      gzip_output
      print_summary

      gzipped_output_path
    end

    private

    attr_reader :local_data_path, :local_model_path, :logger

    def generate_input_file
      logger.info 'Generating input file'
      tty_command.run(glpsol_command)
    end

    def solve_model
      logger.info 'Solving the model'
      tty_command.run(cbc_command)
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
      glpsol -m #{local_model_path}
             -d #{local_data_path}
             --wlp #{lp_path}
             --check
      ).delete("\n")
    end

    def gzip_command
      "gzip < #{output_path} > #{gzipped_output_path}"
    end

    def cbc_command
      %(
        cbc #{lp_path} solve solu #{output_path}
      )
    end

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
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

module Osemosys
  class SolveModel
    def initialize(local_model_path:, local_data_path:, logger: Config.logger)
      @local_data_path = local_data_path
      @local_model_path = local_model_path
      @logger = logger
    end

    def call
      # TODO: save logs
      solve_model
      gzip_output
      print_summary
      File.open(gzipped_output_path)
    end

    private

    attr_reader :local_data_path, :local_model_path, :logger

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
      glpsol -m #{local_model_path}
             -d #{local_data_path}
             -o #{output_path}
      ).delete("\n")
    end

    def gzip_command
      "gzip -f #{output_path}"
    end

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
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
  end
end

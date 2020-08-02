module Osemosys
  module Solvers
    class Cbc
      def initialize(local_model_path:, local_data_path:, run:)
        @local_data_path = local_data_path
        @local_model_path = local_model_path
        @run = run
      end

      def call
        preprocess_data_file if preprocess_data_file?
        generate_input_file
        find_solution
        prepare_results
        postprocess_results if postprocess_results?
        print_summary

        SolvedFiles.new(solved_file_path: zipped_output_path, csv_file_path: zipped_csv_path)
      end

      private

      def preprocess_data_file?
        run.pre_process?
      end

      def postprocess_results?
        run.post_process?
      end

      attr_reader :local_data_path, :local_model_path, :run

      def preprocess_data_file
        run.transition_to!(:preprocessing_data)
        Commands::PreprocessDataFile.new(
          local_data_path: local_data_path,
          preprocessed_data_path: preprocessed_data_path,
        ).call
      end

      def generate_input_file
        run.transition_to!(:generating_matrix)
        input_file = preprocess_data_file? ? preprocessed_data_path : local_data_path
        Commands::GenerateInputFile.new(
          local_model_path: local_model_path,
          local_data_path: input_file,
          lp_path: lp_path,
        ).call
      end

      def find_solution
        run.transition_to!(:finding_solution)
        Commands::FindSolution.new(
          lp_path: lp_path,
          output_path: output_path,
        ).call
      end

      def postprocess_results
        run.transition_to!(:postprocessing)

        Commands::PostProcessResultFiles.new(
          preprocessed_data_path: preprocessed_data_path,
          solution_file_path: output_path,
        ).call

        Commands::ZipFolder.new(
          folder: 'csv/',
          destination: zipped_csv_path,
        ).call
      end

      def print_summary
        Config.logger.info 'Model solved!'
        Config.logger.info ''
        Config.logger.info "run_id: #{Config.run_id}"
      end

      def lp_path
        "./data/input_#{Config.run_id}.lp"
      end

      def output_path
        "./data/output_#{Config.run_id}.txt"
      end

      def zipped_output_path
        "./data/output_#{Config.run_id}.zip"
      end

      def zipped_csv_path
        "./data/csv_#{Config.run_id}.zip"
      end

      def metadata_path
        @metadata_path ||= GenerateMetadata.call(run: run)
      end

      def prepare_results
        PrepareResults.call(
          output_path: output_path,
          data_path: local_data_path,
          metadata_path: metadata_path,
          destination: zipped_output_path,
        )
      end

      def preprocessed_data_path
        "#{local_data_path}.pre"
      end
    end
  end
end

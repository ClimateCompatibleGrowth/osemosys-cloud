class SolveRun
  def initialize(run:, solver:)
    @run = run
    @solver = solver
  end

  def call
    Timeout.timeout run.timeout do
      solve_run
      save_result
    end
  ensure
    AfterFinishHook.new(run: run).call
  end

  private

  attr_reader :run, :solver

  def solve_run
    @solved_files = solver.new(
      local_model_path: local_files.local_model_path,
      local_data_path: local_files.local_data_path,
      run: run,
    ).call
  end

  def save_result
    run_result.result_file.attach(
      io: File.open(@solved_files.solved_file_path),
      filename: File.basename(@solved_files.solved_file_path),
    )
    if run.post_process?
      run_result.csv_results.attach(
        io: File.open(@solved_files.csv_file_path),
        filename: File.basename(@solved_files.csv_file_path),
      )
    end
  end

  def local_files
    if Rails.env.test?
      OpenStruct.new(
        local_model_path: ActiveStorage::Blob.service.send(:path_for, run.model_file.key),
        local_data_path: ActiveStorage::Blob.service.send(:path_for, run.data_file.key),
      )
    else
      Osemosys::DownloadModelFromS3.new(
        s3_data_key: run.data_file.key,
        s3_model_key: run.model_file.key,
      ).call
    end
  end

  def run_result
    @run_result ||= RunResult.create!(run_id: run.id)
  end
end

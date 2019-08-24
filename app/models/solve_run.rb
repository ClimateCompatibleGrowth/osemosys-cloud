class SolveRun
  def initialize(run:, logger: Osemosys::Config.logger, solver:)
    @run = run
    @logger = logger
    @solver = solver
  end

  def call
    solve_run
    save_result
  ensure
    AfterFinishHook.new(run: run).call
  end

  private

  attr_reader :run, :logger, :solver

  def transition_to_ongoing
    run.transition_to!(:ongoing)
  end

  def solve_run
    @solved_file_path = solver.new(
      local_model_path: local_files.local_model_path,
      local_data_path: local_files.local_data_path,
      logger: logger,
      run: run,
    ).call
  end

  def save_result
    run.result_file.attach(
      io: File.open(@solved_file_path),
      filename: File.basename(@solved_file_path),
    )
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
end

class SolveRun
  def initialize(run:, logger: Osemosys::Config.logger)
    @run = run
    @logger = logger
  end

  def call
    set_started_at
    solve_run
    save_result
    perform_after_finish_hook
  ensure
    AfterFinishHook.new(run: run).call
  end

  private

  attr_reader :run, :logger

  def set_started_at
    run.update_attributes(started_at: Time.current)
  end

  def solve_run
    @solved_file_path = Osemosys::SolveCbcModel.new(
      local_model_path: local_files.local_model_path,
      local_data_path: local_files.local_data_path,
      logger: logger,
    ).call
  end

  def save_result
    run.result_file.attach(
      io: File.open(@solved_file_path),
      filename: File.basename(@solved_file_path),
    )
  end

  def perform_after_finish_hook
    AfterFinishHook.new(run: run).call
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

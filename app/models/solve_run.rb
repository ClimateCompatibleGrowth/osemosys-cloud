class SolveRun
  def initialize(run:, logger: Osemosys::Config.logger, solver_class: Osemosys::SolveModel)
    @run = run
    @logger = logger
    @solver_class = solver_class
  end

  def call
    set_started_at
    solve_run
    save_result
    perform_after_finish_hook
  end

  private

  attr_reader :run, :logger, :solver_class

  def set_started_at
    run.update_attributes(started_at: Time.current)
  end

  def solve_run
    local_files = Osemosys::DownloadModelFromS3.new(
      s3_data_key: run.data_file.key,
      s3_model_key: run.model_file.key
    ).call

    @solved_file_path = solver_class.new(
      local_model_path: local_files.local_model_path,
      local_data_path: local_files.local_data_path,
      logger: logger
    ).call
  end

  def save_result
    run.result_file.attach(
      io: File.open(@solved_file_path),
      filename: File.basename(@solved_file_path)
    )
  end

  def perform_after_finish_hook
    log_path = "/tmp/run-#{run.id}.log"
    AfterFinishHook.new(run: run, log_path: log_path).call
  end
end

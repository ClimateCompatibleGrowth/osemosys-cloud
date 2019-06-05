class SolveRun
  def initialize(run:, logger: Osemosys::Config.logger, use_cplex: false)
    @run = run
    @logger = logger
    @use_cplex = use_cplex
  end

  def call
    set_started_at
    solve_run
    save_result
    set_finished_at
    save_log
    # save_cplex_log?
  end

  private

  attr_reader :run, :logger, :use_cplex

  def set_started_at
    run.update_attributes(started_at: Time.current)
  end

  def solve_run
    local_files = Osemosys::DownloadModelFromS3.new(
      s3_data_key: run.data_file.key,
      s3_model_key: run.model_file.key
    ).call

    @solved_file = Osemosys::SolveModel.new(
      local_model_path: local_files.local_model_path,
      local_data_path: local_files.local_data_path,
      logger: logger
    ).call
  end

  def save_result
    run.result_file.attach(
      io: @solved_file,
      filename: File.basename(@solved_file.to_path)
    )
  end

  def save_log
    File.open("./log/run-#{run.id}.log") do |file|
      run.log_file.attach(
        io: file,
        filename: File.basename(file.to_path)
      )
    end
  end

  def set_finished_at
    run.update_attributes(finished_at: Time.current)
  end
end

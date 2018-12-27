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
    if use_cplex
      @solved_file = Osemosys::SolveCplexModel.new(
        s3_data_key: run.data_file.key,
        s3_model_key: run.model_file.key,
        logger: logger
      ).call
    else
      @solved_file = Osemosys::SolveModel.new(
        s3_data_key: run.data_file.key,
        s3_model_key: run.model_file.key,
        logger: logger
      ).call
    end
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

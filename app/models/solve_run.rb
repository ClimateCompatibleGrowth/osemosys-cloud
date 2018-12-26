class SolveRun
  def initialize(run:)
    @run = run
  end

  def call
    set_started_at
    solve_run
    save_result
    set_finished_at
  end

  private

  attr_reader :run

  def set_started_at
    run.update_attributes(started_at: Time.current)
  end

  def solve_run
    @solved_file = Osemosys::SolveModel.new(
      s3_data_key: run.data_file.key,
      s3_model_key: run.model_file.key
    ).call
  end

  def save_result
    run.result_file.attach(
      io: @solved_file,
      filename: File.basename(@solved_file.to_path)
    )
  end

  def set_finished_at
    run.update_attributes(finished_at: Time.current)
  end
end

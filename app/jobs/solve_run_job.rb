class SolveRunJob < ApplicationJob
  queue_as :osemosys
  sidekiq_options retry: 0

  def perform(run_id:)
    @run = Run.find(run_id)

    SolveRun.new(
      run: run,
      solver: Osemosys::Solvers::Cbc,
      logger: Logger.new(run.local_log_path),
    ).call
  end
end

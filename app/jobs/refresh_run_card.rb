class RefreshRunCard < ApplicationJob
  def perform(run_id)
    run = Run.find(run_id)
    run.broadcast_update!
  end
end

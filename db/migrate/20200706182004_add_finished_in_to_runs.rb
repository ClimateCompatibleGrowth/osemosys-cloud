class AddFinishedInToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :finished_in, :integer

    Run.transaction do
      Run.all.each do |run|
        transitions = run.history
        if transitions.last&.final?
          finished_in = transitions.last.created_at - transitions.first.created_at
          run.update(finished_in: finished_in)
        end
      end
    end
  end
end

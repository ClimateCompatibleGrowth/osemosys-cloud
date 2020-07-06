class AddFinishedInToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :finished_in, :integer

    Run.transaction do
      Run.all.each do |run|
        run.update(finished_in: run.solving_time)
      end
    end
  end
end

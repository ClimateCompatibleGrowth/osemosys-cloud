class AddFeasibleToRunResults < ActiveRecord::Migration[6.1]
  def change
    add_column :run_results, :feasible, :boolean
    RunResult.update_all(feasible: true)
  end
end

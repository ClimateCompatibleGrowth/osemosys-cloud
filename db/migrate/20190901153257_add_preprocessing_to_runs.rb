# typed: true
class AddPreprocessingToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :pre_process, :boolean, null: false, default: true
    Run.update_all(pre_process: false)
  end
end

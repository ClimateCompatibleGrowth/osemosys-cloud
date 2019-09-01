class AddPreprocessingToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :pre_process, :boolean, null: false, default: true
  end
end

class RemoveOldProgressColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :runs, :started_at
    remove_column :runs, :queued_at
    remove_column :runs, :finished_at
    remove_column :runs, :outcome
  end
end

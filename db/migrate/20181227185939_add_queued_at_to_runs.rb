class AddQueuedAtToRuns < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :queued_at, :datetime
  end
end

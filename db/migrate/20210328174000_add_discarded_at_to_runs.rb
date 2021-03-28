class AddDiscardedAtToRuns < ActiveRecord::Migration[6.1]
  def change
    add_column :runs, :discarded_at, :datetime
    add_index :runs, :discarded_at
  end
end

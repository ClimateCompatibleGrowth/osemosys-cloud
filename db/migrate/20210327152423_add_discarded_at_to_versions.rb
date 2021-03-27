class AddDiscardedAtToVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :discarded_at, :datetime
    add_index :versions, :discarded_at
  end
end

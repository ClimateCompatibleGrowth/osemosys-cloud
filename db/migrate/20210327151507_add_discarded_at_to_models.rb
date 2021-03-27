class AddDiscardedAtToModels < ActiveRecord::Migration[6.1]
  def change
    add_column :models, :discarded_at, :datetime
    add_index :models, :discarded_at
  end
end

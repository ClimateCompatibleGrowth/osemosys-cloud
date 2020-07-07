class CreateVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :versions do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end

    add_reference :runs, :version, foreign_key: true
  end
end

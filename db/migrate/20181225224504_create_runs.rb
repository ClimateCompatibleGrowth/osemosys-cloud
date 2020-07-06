# typed: true
class CreateRuns < ActiveRecord::Migration[5.2]
  def change
    create_table :runs do |t|
      t.string :name
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end
  end
end

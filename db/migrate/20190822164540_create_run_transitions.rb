# typed: true
class CreateRunTransitions < ActiveRecord::Migration[6.0]
  def change
    create_table :run_transitions do |t|
      t.string :to_state, null: false
      t.json :metadata, default: {}
      t.integer :sort_key, null: false
      t.integer :run_id, null: false
      t.boolean :most_recent, null: false
      t.timestamps null: false
    end

    add_foreign_key :run_transitions, :runs

    add_index(:run_transitions,
              %i(run_id sort_key),
              unique: true,
              name: "index_transitions_parent_sort")
    add_index(:run_transitions,
              %i(run_id most_recent),
              unique: true,
              where: "most_recent",
              name: "index_transitions_parent_most_recent")

    add_column :runs, :state, :string, null: false, default: 'new'
  end
end

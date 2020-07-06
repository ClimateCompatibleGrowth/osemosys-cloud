# typed: true
class AddDescriptionToRuns < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :description, :text, null: false, default: ''
  end
end

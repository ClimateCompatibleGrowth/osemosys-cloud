# typed: true
class AddOutcomeToRuns < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :outcome, :string
  end
end

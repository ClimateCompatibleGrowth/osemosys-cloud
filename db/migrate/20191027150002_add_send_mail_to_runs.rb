# typed: true
class AddSendMailToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :notify_when_finished, :boolean, null: false, default: true
  end
end

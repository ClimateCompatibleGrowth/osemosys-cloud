# typed: true
class AddRunsVisibleToAdminsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :runs_visible_to_admins, :boolean, null: false, default: true
  end
end

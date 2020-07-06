# typed: true
class AddUserIdToRuns < ActiveRecord::Migration[5.2]
  def change
    add_reference :runs, :user, index: true
    Run.update_all(user_id: 1)
    add_foreign_key :runs, :users
  end
end

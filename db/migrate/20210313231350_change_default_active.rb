class ChangeDefaultActive < ActiveRecord::Migration[6.1]
  def change
    User.update_all(active: true)
    change_column_default :users, :active, :true
  end
end

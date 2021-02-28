class AddInformationToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, default: '', null: false
    add_column :users, :country_code, :string
    add_column :users, :active, :boolean, default: false, null: false
  end
end

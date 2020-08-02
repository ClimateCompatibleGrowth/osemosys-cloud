class AddServerTypeToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :server_type, :string
    Run.update_all(server_type: 'z1d.3xlarge')
    change_column_null :runs, :server_type, false
  end
end

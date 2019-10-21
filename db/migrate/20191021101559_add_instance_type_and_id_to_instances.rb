class AddInstanceTypeAndIdToInstances < ActiveRecord::Migration[6.0]
  def change
    add_column :ec2_instances, :instance_type, :string
    add_column :ec2_instances, :aws_id, :string
  end
end

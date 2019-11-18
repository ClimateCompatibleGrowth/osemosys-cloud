class AddPostprocessingToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :post_process, :boolean, null: false, default: true
    Run.update_all(post_process: false)
  end
end

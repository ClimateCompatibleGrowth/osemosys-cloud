class AddCachedResFileThumbUrl < ActiveRecord::Migration[6.1]
  def change
    add_column :runs, :cached_res_thumbnail_url, :string
  end
end

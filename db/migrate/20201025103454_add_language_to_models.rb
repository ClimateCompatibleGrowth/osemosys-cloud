class AddLanguageToModels < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :language, :string, null: false, default: 'en'
  end
end

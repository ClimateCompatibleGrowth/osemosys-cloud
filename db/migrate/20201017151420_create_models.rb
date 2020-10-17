class CreateModels < ActiveRecord::Migration[6.0]
  def change
    create_table :models do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end

    add_reference :versions, :model, foreign_key: true

    Model.transaction do
      Version.all.group_by(&:user_id).each do |user_id, versions|
        model = Model.create!(name: '(No Model)', user_id: user_id)
        versions.each { |version| version.update(model: model) }
      end
    end
  end
end

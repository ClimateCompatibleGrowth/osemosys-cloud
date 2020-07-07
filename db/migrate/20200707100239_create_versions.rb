class CreateVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :versions do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end

    add_reference :runs, :version, foreign_key: true

    Version.transaction do
      Run.all.group_by(&:user_id).each do |user_id, runs|
        version = Version.create!(name: 'Old runs', user_id: user_id)
        runs.each { |run| run.update(version: version) }
      end
    end
  end
end

class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :run_results do |t|
      t.references :run, foreign_key: true

      t.timestamps
    end

    Run.transaction do
      Run.where(state: 'succeeded').each do |run|
        result = RunResult.create!(run_id: run.id)

        puts "transferring results from run #{run.id} to result id #{result.id}"
        ActiveStorage::Attachment.where(name: 'result_file', record_type: 'Run', record_id: run.id)
          .update_all(record_type: 'RunResult', record_id: result.id)
        ActiveStorage::Attachment.where(name: 'csv_results', record_type: 'Run', record_id: run.id)
          .update_all(record_type: 'RunResult', record_id: result.id)
      end
    end
  end
end

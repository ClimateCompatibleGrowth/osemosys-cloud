require 'rails_helper'
require 'rake'

RSpec.describe 'Running a run' do
  it 'Solves the run' do
    User.create!(email: 'test@example.com', password: 'blehbleh')
    run = create_run

    expect(run.queued_at).to be nil
    expect(run.started_at).to be nil
    expect(run.finished_at).to be nil
    expect(run.outcome).to be nil

    OsemosysCloud::Application.load_tasks
    Rake::Task['solve_cbc_run'].invoke(run.id)

    run.reload
    expect(run.queued_at).to be nil
    expect(run.started_at).to be_past
    expect(run.finished_at).to be_past
    expect(run.outcome).to eq('success')
  end

  def create_run
    run = Run.create!(
      name: 'My run',
      description: 'My description',
      user_id: User.last.id
    )

    run.data_file.attach(
      io: File.open("#{Rails.root}/spec/data/atlantis_data.txt"),
      filename: 'atlantis_data.txt'
    )

    run.model_file.attach(
      io: File.open("#{Rails.root}/spec/data/atlantis_model.txt"),
      filename: 'atlantis_model.txt'
    )

    run
  end
end

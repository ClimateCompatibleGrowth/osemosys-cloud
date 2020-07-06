require 'rails_helper'
require 'rake'

RSpec.describe 'Running a run' do
  it 'Solves a valid run without preprocessing' do
    run = create(:run, :queued, :atlantis, post_process: false)
    expect(run.state).to eq('queued')

    OsemosysCloud::Application.load_tasks if Rake::Task.tasks.empty?
    Rake::Task['solve_cbc_run'].invoke(run.id)
    Rake::Task['solve_cbc_run'].reenable

    run.reload
    expect(run.state).to eq('succeeded')

    expect(run.log_file).to be_present
    expect(run.result_file.attached?).to be true
  end

  it 'Solves a valid run with pre and post processing' do
    run = create(:run, :queued, :atlantis_preprocessed, post_process: true)
    expect(run.state).to eq('queued')

    OsemosysCloud::Application.load_tasks if Rake::Task.tasks.empty?
    Rake::Task['solve_cbc_run'].invoke(run.id)
    Rake::Task['solve_cbc_run'].reenable

    run.reload
    expect(run.state).to eq('succeeded')

    expect(run.log_file).to be_present
    expect(run.result_file.attached?).to be true
    expect(run.csv_results.attached?).to be true
  end

  it 'Handles a faulty run' do
    run = create(:run, :queued, :faulty)
    expect(run.state).to eq('queued')

    OsemosysCloud::Application.load_tasks if Rake::Task.tasks.empty?
    expect {
      Rake::Task['solve_cbc_run'].invoke(run.id)
    }.to raise_error(TTY::Command::ExitError)
    Rake::Task['solve_cbc_run'].reenable

    run.reload
    expect(run.state).to eq('failed')

    expect(run.log_file).to be_present
    expect(run.result_file).to be(nil)
  end
end

require 'rails_helper'
require 'rake'

RSpec.describe 'Running a run' do
  it 'Solves a valid run' do
    run = create(:run, :atlantis)

    expect(run.queued_at).to be nil
    expect(run.started_at).to be nil
    expect(run.finished_at).to be nil
    expect(run.outcome).to be nil

    OsemosysCloud::Application.load_tasks
    Rake::Task['solve_cbc_run'].invoke(run.id)
    Rake::Task['solve_cbc_run'].reenable

    run.reload
    expect(run.queued_at).to be nil
    expect(run.started_at).to be_past
    expect(run.finished_at).to be_past
    expect(run.outcome).to eq('success')

    expect(run.log_file).to be_present
    expect(run.result_file.attached?).to be true
  end

  it 'Handles a faulty run' do
    run = create(:run, :faulty)

    expect(run.queued_at).to be nil
    expect(run.started_at).to be nil
    expect(run.finished_at).to be nil
    expect(run.outcome).to be nil

    OsemosysCloud::Application.load_tasks
    expect {
      Rake::Task['solve_cbc_run'].invoke(run.id)
    }.to raise_error(TTY::Command::ExitError)
    Rake::Task['solve_cbc_run'].reenable

    run.reload
    expect(run.queued_at).to be nil
    expect(run.started_at).to be_past
    expect(run.finished_at).to be_past
    expect(run.outcome).to eq('failure')

    expect(run.log_file).to be_present
    expect(run.result_file.attached?).to be false
  end
end

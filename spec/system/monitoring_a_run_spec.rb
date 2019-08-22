require 'rails_helper'

RSpec.describe 'Creating a run', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for logged in users' do
    user = create :user
    sign_in(user)
    run = create(:run, name: 'Run number 1', user: user)

    visit runs_path

    expect(page).to have_content('Run number 1 (Not started yet)')
    within('.timeline__item--current') do
      expect(page).to have_content('Created')
    end

    expect(page).to have_content('Start run')

    run.update(queued_at: Time.current)
    run.transition_to(:queued)
    visit current_path

    expect(page).to have_content('Run number 1 (In queue)')
    within('.timeline__item--current') do
      expect(page).to have_content('Queued')
    end

    run.update(started_at: Time.current)
    run.transition_to(:ongoing)
    visit current_path

    expect(page).to have_content('Run number 1 (Ongoing)')
    within('.timeline__item--current') do
      expect(page).to have_content('Ongoing')
    end

    run.update(finished_at: Time.current)
    run.update(outcome: 'success')
    run.transition_to(:succeeded)
    visit current_path

    expect(page).to have_content('Run number 1 (Success)')
    expect(page).to have_content('Run finished in 00:00:00')
  end
end

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

    expect(page).to have_content('Run number 1 (New)')
    expect(page).to have_content('Created')

    expect(page).to have_content('Start run')

    run.transition_to(:queued)
    visit current_path

    expect(page).to have_content('Run number 1 (Queued)')
    within('.timeline__item--current') do
      expect(page).to have_content('Queued')
    end

    run.transition_to(:ongoing)
    visit current_path

    expect(page).to have_content('Run number 1 (Ongoing)')
    within('.timeline__item--current') do
      expect(page).to have_content('Ongoing')
    end

    run.transition_to(:succeeded)
    visit current_path

    expect(page).to have_content('Run number 1 (Succeeded)')
    expect(page).to have_content('Run finished in 00:00:00')
  end
end

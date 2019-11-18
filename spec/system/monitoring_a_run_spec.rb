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
    expect(page).to have_content('Start run')

    run.transition_to(:queued)
    visit current_path

    expect(page).to have_content('Run number 1 (Creating server)')
    within('.timeline__item--current') do
      expect(page).to have_content('Creating server')
    end

    run.transition_to!(:preprocessing_data)
    visit current_path
    within('.timeline__item--current') do
      expect(page).to have_content('Preprocessing data')
    end

    run.transition_to!(:generating_matrix)
    visit current_path
    within('.timeline__item--current') do
      expect(page).to have_content('Generating matrix')
    end

    run.transition_to!(:finding_solution)
    visit current_path
    within('.timeline__item--current') do
      expect(page).to have_content('Solving model')
    end

    expect(page).to have_content('Run number 1 (Solving model)')
    within('.timeline__item--current') do
      expect(page).to have_content('Solving model')
    end

    run.transition_to!(:postprocessing)
    visit current_path
    within('.timeline__item--current') do
      expect(page).to have_content('Postprocessing result')
    end

    run.transition_to(:succeeded)
    visit current_path

    expect(page).to have_content('Run number 1 (Succeeded)')
    expect(page).to have_content('Run finished in 00:00:00')
  end
end

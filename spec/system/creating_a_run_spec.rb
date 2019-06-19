require 'rails_helper'

RSpec.describe 'Creating a run', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works' do
    visit root_path

    expect(page).to have_text('Osemosys Cloud')

    click_on 'New run'

    expect(page).to have_text('Schedule a new run')

    fill_in 'Name', with: 'Atlantis'
    fill_in 'Description', with: 'A Place Long Gone'

    atlantis_model = "#{Rails.root}/spec/data/atlantis_model.txt"
    atlantis_data = "#{Rails.root}/spec/data/atlantis_data.txt"

    attach_file 'run_model_file', atlantis_model
    attach_file 'run_data_file', atlantis_data

    click_on 'Create run'

    expect(page).to have_text 'Atlantis'
    expect(page).to have_text 'A Place Long Gone'
  end
end

require 'rails_helper'

RSpec.describe 'Creating a run', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for logged in users' do
    user = create(:user)
    sign_in(user)
    version = create(:version, name: 'Ethopia 2014', user: user)
    visit version_path(version)

    expect(page).to have_text('Osemosys Cloud')

    click_on 'New run'

    expect(page).to have_text('Schedule a new run')
    # Preselected version
    expect(page.find('#run_version_id').value).to eq(version.id.to_s)

    fill_in 'Name', with: 'Atlantis'
    fill_in 'Description', with: 'A Place Long Gone'

    select('Large server', from: 'run_server_type')

    atlantis_model = "#{Rails.root}/spec/data/atlantis_model.txt"
    atlantis_data = "#{Rails.root}/spec/data/atlantis_data.txt"

    attach_file 'run_model_file', atlantis_model
    attach_file 'run_data_file', atlantis_data

    click_on 'Create run'

    expect(page).to have_text 'Atlantis'
    expect(page).to have_text 'Run created'
    expect(page).to have_text 'A Place Long Gone'
  end

  it 'redirects to root for logged out users' do
    visit root_path

    expect(page).to have_text('Sign in or register to start.')

    visit versions_path

    expect(page).to have_text('You need to sign in or sign up before continuing.')
  end
end

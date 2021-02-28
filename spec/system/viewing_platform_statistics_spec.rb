require 'rails_helper'

RSpec.describe 'Viewing the admin stats', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for admin in users' do
    normal_user = create(:user)
    admin = create(:user, :admin)
    create(:run, user: normal_user)
    create(:run, user: normal_user)

    sign_in(admin)
    visit admin_stats_path
    expect(page).to have_content('Platform statistics')
    expect(page).to have_content('Registered users: 2')
    expect(page).to have_content('Total server time used:')
  end
end

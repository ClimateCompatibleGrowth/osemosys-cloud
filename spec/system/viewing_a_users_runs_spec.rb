require 'rails_helper'

RSpec.describe 'Viewing the admin stats', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for admins when a user agreed to share their runs' do
    normal_user = create(:user)
    admin = create(:user, :admin)
    create(:run, :ongoing, name: 'My Run 1', user: normal_user)
    create(:run, :finished, name: 'My Run 2', user: normal_user)
    create(:run, :finished, name: 'My Run 3', user: normal_user)

    sign_in(admin)
    visit admin_user_runs_path(normal_user)
    expect(page).to have_content("Showing runs for #{normal_user.email}")
    expect(page).to have_content('My Run 1')
    expect(page).to have_content('My Run 2')
    expect(page).to have_content('My Run 3')
  end

  it 'shows an error message when the user has not agreed to share their runs' do
    normal_user = create(:user, runs_visible_to_admins: false)
    admin = create(:user, :admin)
    create(:run, :ongoing, name: 'My Run 1', user: normal_user)

    sign_in(admin)
    visit admin_user_runs_path(normal_user)
    expect(page).not_to have_content("Showing runs for #{normal_user.email}")
    expect(page).not_to have_content('My Run 1')
    expect(page).to have_content('Not allowed to see runs for this user')
  end

  it 'redirects to root for non admin users' do
    normal_user = create(:user)
    sign_in(normal_user)
    visit admin_user_runs_path(normal_user)
    expect(page).not_to have_content('User statistics')
    expect(page).to have_current_path('/models')
  end

  it 'redirects to root for non signed in users' do
    normal_user = create(:user)
    visit admin_user_runs_path(normal_user)
    expect(page).not_to have_content('User statistics')
    expect(page).to have_current_path('/users/sign_in')
  end
end

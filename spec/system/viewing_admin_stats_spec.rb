require 'rails_helper'

RSpec.describe 'Viewing the admin stats', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for admin in users' do
    normal_user = create(:user)
    admin = create(:user, :admin)
    create(:run, :ongoing, user: normal_user)
    create(:run, :finished, user: normal_user)
    create(:run, :finished, user: normal_user, name: 'Last run')

    sign_in(admin)
    visit admin_user_stats_path
    expect(page).to have_content('User statistics')
    expect(page).to have_current_path('/admin/user_stats')
    expect(page).to have_content(normal_user.email)
    expect(page).to have_content('2')

    click_on(normal_user.email)
    expect(page).to have_content("Statistics for #{normal_user.email}")
    expect(page).to have_content('Last run')
    expect(page).to have_content('Succeeded: 2')
    expect(page).to have_content('Solving model: 1')
  end

  it 'redirects to root for non admin users' do
    sign_in(create(:user))
    visit admin_user_stats_path
    expect(page).not_to have_content('User statistics')
    expect(page).to have_current_path('/models')
  end

  it 'redirects to root for non signed in users' do
    visit admin_user_stats_path
    expect(page).not_to have_content('User statistics')
    expect(page).to have_current_path('/users/sign_in')
  end
end

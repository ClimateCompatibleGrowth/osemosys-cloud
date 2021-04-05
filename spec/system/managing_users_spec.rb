require 'rails_helper'

RSpec.describe 'Managing users as an admin', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for admin in users' do
    normal_user = create(:user, country_code: 'GB', name: 'John Doe')
    swedish_user = create(:user, country_code: 'SE')
    admin = create(:user, :admin, country_code: 'GB')
    create(:run, :ongoing, user: normal_user)
    create(:run, :finished, user: normal_user)
    create(:run, :finished, user: normal_user, name: 'Last run')
    ActsAsTaggableOn::Tag.create!(name: 'My tag')
    ActsAsTaggableOn::Tag.create!(name: 'My other tag')

    sign_in(admin)
    visit admin_users_path
    expect(page).to have_content('User statistics')
    expect(page).to have_current_path('/admin/users')
    expect(page).to have_content(normal_user.email)
    expect(page).to have_content(swedish_user.email)
    expect(page).to have_content(admin.email)
    expect(page).to have_content('Last run')

    select('Sweden', from: 'Country')
    click_on('Search')

    within('.table') do
      expect(page).to have_content(swedish_user.email)
      expect(page).not_to have_content(normal_user.email)
      expect(page).not_to have_content(admin.email)
    end

    click_on('Clear')

    click_on(normal_user.email)
    expect(page).to have_content("Viewing user #{normal_user.email}")
    within '.row' do
      expect(page).to have_content('John Doe')
      expect(page).to have_content('United Kingdom')
      click_on 'Edit'
    end

    expect(page).to have_content("Editing John Doe (#{normal_user.id})")
    fill_in :name, with: 'Jane Doe'
    select '', from: 'Country'
    click_on 'Update User'

    expect(page).to have_content("Country can't be blank")

    select 'Sweden', from: 'Country'
    select 'My tag', from: 'Tags'
    click_on 'Update User'

    expect(page).to have_content('User updated')
    expect(page).to have_content('Sweden')
    expect(page).to have_content('My tag')
    expect(page).not_to have_content('My other tag')

    click_on('View runs')

    expect(page).to have_selector('.run-card', count: 3)
  end

  it 'redirects to root for non admin users' do
    sign_in(create(:user))
    visit admin_users_path
    expect(page).not_to have_content('User statistics')
    expect(page).to have_current_path('/models')
  end

  it 'redirects to root for non signed in users' do
    visit admin_users_path
    expect(page).not_to have_content('User statistics')
    expect(page).to have_current_path('/users/sign_in')
  end
end

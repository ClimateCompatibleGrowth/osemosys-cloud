require 'rails_helper'

RSpec.describe UsersToCsv do
  it 'is a string with the user info' do
    user1 = create(
      :user,
      name: 'User 1',
      email: 'user1@gmail.com',
      country_code: 'SE',
      created_at: Time.zone.parse('2020-10-01'),
    )
    user2 = create(
      :user,
      name: 'User 2',
      email: 'user2@gmail.com',
      country_code: 'GB',
      created_at: Time.zone.parse('2020-10-02'),
    )
    create(:run, user: user2, finished_in: 10, created_at: Time.zone.parse('2020-11-01'))

    result = UsersToCsv.new([user1, user2]).generate

    expect(result).to eq <<~CSV
      Id,Full name,Email,Country,Registration date,Runs,Last run at,Server time
      #{user1.id},User 1,user1@gmail.com,Sweden, 1 Oct 2020,0,-,00:00:00
      #{user2.id},User 2,user2@gmail.com,United Kingdom, 2 Oct 2020,1, 1 Nov 2020,00:00:10
    CSV
  end
end

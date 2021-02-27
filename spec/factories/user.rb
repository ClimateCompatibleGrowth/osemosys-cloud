FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    email { generate :email }
    name { 'User' }
    country_code { 'SE' }
    locale { 'en' }
    password { 'f4k3p455w0rd' }

    trait :admin do
      admin { true }
    end
  end
end

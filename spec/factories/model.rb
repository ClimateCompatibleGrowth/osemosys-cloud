FactoryBot.define do
  sequence :model_name do |n|
    "My model #{n}"
  end

  factory :model do
    name { generate :model_name }
    user
  end
end

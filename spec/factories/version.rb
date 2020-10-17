FactoryBot.define do
  sequence :version_name do |n|
    "My version #{n}"
  end

  factory :version do
    name { generate :version_name }
    user
    model
  end
end

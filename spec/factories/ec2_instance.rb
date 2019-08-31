FactoryBot.define do
  factory :ec2_instance, class: Ec2::Instance do
    run
  end
end

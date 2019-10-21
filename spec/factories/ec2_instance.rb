FactoryBot.define do
  factory :ec2_instance, class: Ec2::Instance do
    run
    instance_type { 't2.micro' }
    aws_id { SecureRandom.alphanumeric(10) }
  end
end

FactoryBot.define do
  factory :run do
    name { 'My run' }
    description { 'My description' }
    user

    trait :atlantis do
      data_file do
        fixture_file_upload(
          Rails.root.join('spec', 'data', 'atlantis_data.txt'),
          'text/plain',
        )
      end

      model_file do
        fixture_file_upload(
          Rails.root.join('spec', 'data', 'atlantis_model.txt'),
          'text/plain',
        )
      end
    end

    trait :faulty do
      data_file do
        fixture_file_upload(
          Rails.root.join('spec', 'data', 'empty_file.txt'),
          'text/plain',
        )
      end

      model_file do
        fixture_file_upload(
          Rails.root.join('spec', 'data', 'empty_file.txt'),
          'text/plain',
        )
      end
    end
  end
end

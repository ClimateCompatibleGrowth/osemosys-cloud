FactoryBot.define do
  factory :run do
    name { 'My run' }
    description { 'My description' }
    user

    trait :queued do
      state { 'queued' }
      after(:create) { |run| run.transition_to!(:queued) }
    end

    trait :ongoing do
      state { 'ongoing' }
      queued
      after(:create) { |run| run.transition_to!(:ongoing) }
    end

    trait :finished do
      state { 'succeeded' }
      ongoing
      after(:create) { |run| run.transition_to!(:succeeded) }
    end

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

    trait :with_result do
      result_file do
        fixture_file_upload(
          Rails.root.join('spec', 'data', 'empty_file.txt'),
          'text/plain',
        )
      end
    end

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

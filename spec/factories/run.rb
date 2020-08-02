FactoryBot.define do
  factory :run do
    name { 'My run' }
    description { 'My description' }
    version
    user
    server_type { 'z1d.3xlarge' }

    trait :queued do
      state { 'queued' }
      after(:create) { |run| run.transition_to!(:queued) }
    end

    trait :ongoing do
      state { 'ongoing' }
      queued
      after(:create) do |run|
        run.transition_to!(:generating_matrix)
        run.transition_to!(:finding_solution)
      end
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
      run_result
    end

    trait :atlantis do
      pre_process { false }
      post_process { false }

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

    trait :atlantis_preprocessed do
      pre_process { true }
      post_process { true }

      data_file do
        fixture_file_upload(
          Rails.root.join('spec', 'data', 'atlantis_data_preprocessing.txt'),
          'text/plain',
        )
      end

      model_file do
        fixture_file_upload(
          Rails.root.join('spec', 'data', 'osemosys_with_preprocessed.txt'),
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

FactoryBot.define do
  factory :run_result do
    run
    result_file do
      fixture_file_upload(
        Rails.root.join('spec', 'data', 'empty_file.txt'),
        'text/plain',
      )
    end
  end
end

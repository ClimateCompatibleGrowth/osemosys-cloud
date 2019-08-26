FactoryBot.define do
  factory :run_transition do
    run
    to_state { 'queued' }
  end
end

require 'rails_helper'

RSpec.describe Run::StateMachine do
  it 'sets the duration metadata on the last transition when transitioning' do
    run = create(:run)
    run.transition_to!(:queued)
    sleep(0.5)
    run.transition_to!(:generating_matrix)

    transition_to_queued = run.history.first
    expect(transition_to_queued.metadata).to(include('duration'))
    expect(transition_to_queued.metadata['duration']).to(
      be_within(0.1).of(0.5),
    )
  end

  it 'sets the state on run after transitioning' do
    run = create(:run)
    expect(run.state).to eq('new')
    run.transition_to!(:queued)
    expect(run.reload.state).to eq('queued')
  end
end

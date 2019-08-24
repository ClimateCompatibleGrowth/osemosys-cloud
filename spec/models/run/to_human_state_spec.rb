require 'rails_helper'

RSpec.describe Run::ToHumanState do
  it 'has descriptions for all states' do
    possible_states = Run::StateMachine.states

    possible_states.each do |state|
      expect(Run::ToHumanState::HUMANIZED_STATES[state.to_sym]).not_to be_nil
    end
  end

  it 'translates the state to a human readable name' do
    expect(Run::ToHumanState.call(state_slug: 'queued')).to eq('Creating server')
  end
end

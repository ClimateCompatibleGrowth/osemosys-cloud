# typed: false
require 'rails_helper'

RSpec.describe RunTransition do
  describe 'humanized_to_state' do
    it 'delegates to Run::ToHumanState' do
      transition = build(:run_transition, to_state: 'my-state')
      allow(Run::ToHumanState).to(
        receive(:call).with(state_slug: 'my-state').and_return('My State'),
      )

      expect(transition.humanized_to_state).to eq('My State')
    end
  end

  describe 'final?' do
    it 'is true when the run the transition is to a succeeded or failed state' do
      transition_to_success = build(:run_transition, to_state: 'succeeded')
      transition_to_failure = build(:run_transition, to_state: 'failed')
      intermediate_transition = build(:run_transition, to_state: 'queued')

      expect(transition_to_success.final?).to be true
      expect(transition_to_failure.final?).to be true
      expect(intermediate_transition.final?).to be false
    end
  end

  describe 'duration' do
    it 'is the duration metadata when it exists' do
      transition = build(:run_transition, metadata: { 'duration' => 'foo' })

      expect(transition.duration).to eq('foo')
    end
  end
end

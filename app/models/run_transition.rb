class RunTransition < ApplicationRecord
  validates :to_state, inclusion: { in: Run::StateMachine.states }

  belongs_to :run, inverse_of: :run_transitions

  def humanized_to_state
    to_state.capitalize.to_s
  end
end

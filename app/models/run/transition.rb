class Run < ApplicationRecord
  class Transition < ApplicationRecord
    validates :to_state, inclusion: { in: Run::StateMachine.states }

    belongs_to :run, inverse_of: :run_transitions
  end
end

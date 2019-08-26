class Run < ApplicationRecord
  class StateMachine
    include Statesman::Machine

    state :new, initial: true
    state :queued
    state :ongoing # Legacy
    state :generating_matrix
    state :finding_solution
    state :succeeded
    state :failed

    transition from: :new, to: %i[queued ongoing succeeded failed]
    transition from: :queued, to: :generating_matrix
    transition from: :generating_matrix, to: %i[finding_solution failed]
    transition from: :finding_solution, to: %i[succeeded failed]

    after_transition do |run, transition|
      run.state = transition.to_state
      run.save!
    end

    before_transition do |run, _new_transition|
      last_transition = run.last_transition
      if last_transition
        duration = Time.current - last_transition.created_at
        last_transition.metadata[:duration] = duration
        last_transition.save
      end
    end
  end
end

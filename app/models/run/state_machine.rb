class Run < ApplicationRecord
  class StateMachine
    include Statesman::Machine

    state :new, initial: true
    state :queued
    state :ongoing
    state :generating_matrix
    state :finding_solution
    state :succeeded
    state :failed

    transition from: :new, to: %i[queued ongoing succeeded failed]
    transition from: :queued, to: :generating_matrix
    transition from: :generating_matrix, to: %i[finding_solution failed]
    transition from: :finding_solution, to: %i[succeeded failed]

    after_transition do |model, transition|
      model.state = transition.to_state
      model.save!
    end
  end
end

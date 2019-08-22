class Run < ApplicationRecord
  class StateMachine
    include Statesman::Machine

    state :new, initial: true
    state :queued
    state :ongoing
    state :succeeded
    state :failed

    transition from: :new, to: %i[queued ongoing succeeded failed]
    transition from: :queued, to: :ongoing
    transition from: :ongoing, to: %i[succeeded failed]

    after_transition do |model, transition|
      model.state = transition.to_state
      model.save!
    end
  end
end

class Run < ApplicationRecord
  class StateMachine
    include Statesman::Machine

    state :new, initial: true
    state :queued
    state :ongoing
    state :succeeded
    state :failed

    transition from: :new, to: :queued
    transition from: :queued, to: :ongoing
    transition from: :ongoing, to: %i[succeeded failed]
  end
end

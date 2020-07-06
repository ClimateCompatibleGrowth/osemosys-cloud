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
    state :preprocessing_data
    state :postprocessing

    transition from: :new, to: %i[queued]
    transition from: :queued, to: %i[generating_matrix preprocessing_data]
    transition from: :preprocessing_data, to: %i[generating_matrix failed]
    transition from: :generating_matrix, to: %i[finding_solution failed]
    transition from: :finding_solution, to: %i[postprocessing succeeded failed]
    transition from: :postprocessing, to: %i[succeeded failed]

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

    after_transition(to: %i[succeeded failed]) do |run, _new_transition|
      run.update!(finished_in: solving_time_for(run))
    end

    private

    def solving_time_for(run)
      transitions = run.history

      return unless transitions.last&.final?

      transitions.last.created_at - transitions.first.created_at
    end
  end
end

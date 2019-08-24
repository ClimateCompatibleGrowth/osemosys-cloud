class Run < ApplicationRecord
  class NewTimeline
    def initialize(run)
      @run = run
    end

    def current_state
      run.state
    end

    def created_at
      run.created_at
    end

    def past_transitions
      all_transitions[0...-1]
    end

    def last_transition
      return unless all_transitions.present?

      all_transitions[-1]
    end

    def past_states_transitions
      run.history
      # return [] if current_index.zero?

      # states[0..(current_index - 1)]
    end

    # def future
    #   states[(current_index + 1)..-1]
    # end

    private

    attr_reader :run

    def all_transitions
      @all_transitions ||= run.history
    end
  end
end

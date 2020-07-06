# typed: true
class Run < ApplicationRecord
  class Timeline
    def initialize(run)
      @run = run
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

    private

    attr_reader :run

    def all_transitions
      @all_transitions ||= run.history
    end
  end
end

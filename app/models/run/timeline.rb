class Run < ApplicationRecord
  class Timeline
    STATES = %w[Created Queued Ongoing Finished]

    def initialize(run)
      @run = run
    end

    def current
      STATES[current_index]
    end

    def passed
      return [] if current_index.zero?
      STATES[0..(current_index - 1)]
    end

    def future
      STATES[(current_index + 1)..-1]
    end

    private

    attr_reader :run

    def current_index
      return 3 if run.finished?
      return 2 if run.started?
      return 1 if run.in_queue?
      0
    end
  end
end

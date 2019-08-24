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
    def transitions
      run.history
    end

    def last_transition
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

    def current_index
      return 3 if run.finished?
      return 2 if run.started?
      return 1 if run.in_queue?

      0
    end

    def states
      [
        {
          name: 'Created',
          timestamp: run.created_at,
        },
        {
          name: 'Queued',
          timestamp: run.queued_at,
        },
        {
          name: 'Ongoing',
          timestamp: run.started_at,
        },
        {
          name: 'Finished',
          timestamp: run.finished_at,
        },
      ]
    end
  end
end

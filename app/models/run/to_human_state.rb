class Run < ApplicationRecord
  class ToHumanState
    HUMANIZED_STATES = {
      new: 'New',
      queued: 'Creating server',
      ongoing: 'Ongoing',
      succeeded: 'Succeeded',
      failed: 'Failed',
    }

    def self.call(run:)
      new(run: run).call
    end

    def initialize(run:)
      @run = run
    end

    def call
      HUMANIZED_STATES[run.state.to_sym]
    end

    private

    attr_reader :run
  end
end

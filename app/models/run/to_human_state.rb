class Run < ApplicationRecord
  class ToHumanState
    HUMANIZED_STATES = {
      new: 'New',
      queued: 'Creating server',
      ongoing: 'Ongoing',
      succeeded: 'Succeeded',
      failed: 'Failed',
      finding_solution: 'Solving model',
      generating_matrix: 'Generating matrix',
    }

    def self.call(state_slug:)
      new(state_slug: state_slug).call
    end

    def initialize(state_slug:)
      @state_slug = state_slug
    end

    def call
      HUMANIZED_STATES[state_slug.to_sym]
    end

    private

    attr_reader :state_slug
  end
end

class Run < ApplicationRecord
  class Timeline
    def initialize(run)
      @run = run
    end

    def current
      return '' if run.finished?
      return 'Ongoing' if run.started?
      return 'Queued' if run.in_queue?
      ''
    end

    def passed
      return 'Queued > Ongoing > Finished' if run.finished?
      return 'Queued >' if run.started?
      return '' if run.in_queue?
      ''
    end

    def future
      return '' if run.finished?
      return '> Finished' if run.started?
      return '> Ongoing > Finished' if run.in_queue?
      'Queued > Ongoing > Finished'
    end

    private

    attr_reader :run
  end
end

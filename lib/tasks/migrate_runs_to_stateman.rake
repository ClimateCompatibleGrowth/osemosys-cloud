task migrate_runs_to_stateman: :environment do
  Run.transaction do
    Run.all.each do |run|
      if run.queued_at?
        run.transition_to!(:queued)
        run.last_transition.update(created_at: run.queued_at)
      end

      if run.started_at?
        run.transition_to!(:ongoing)
        run.last_transition.update(created_at: run.started_at)
      end

      next unless run.outcome.present?

      if run.outcome == 'success'
        run.transition_to!(:succeeded)
        run.last_transition.update(created_at: run.finished_at)
      elsif run.outcome == 'failure'
        run.transition_to!(:failed)
        run.last_transition.update(created_at: run.finished_at)
      end
    end

    Run.in_state(:ongoing).each do |run|
      run.transition_to!(:succeeded)
      if run.finished_at
        run.last_transition.update(created_at: run.finished_at)
      end
    end
  end
end

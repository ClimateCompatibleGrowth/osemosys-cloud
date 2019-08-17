class AfterFinishHook
  def initialize(run:)
    @run = run
  end

  def call
    set_finished_at
    set_outcome
    upload_log_file
  end

  private

  attr_reader :run

  def set_finished_at
    run.update_attributes(finished_at: Time.current)
  end

  def upload_log_file
    run.log_file.attach(
      io: File.open(log_path),
      filename: File.basename(log_path),
    )
  end

  def set_outcome
    run.update_attributes(outcome: outcome)
  end

  def log_path
    run.local_log_path
  end

  def outcome
    if run.result_file.attached?
      'success'
    else
      'failure'
    end
  end
end

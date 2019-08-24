class AfterFinishHook
  def initialize(run:)
    @run = run
  end

  def call
    transition_to_next_state
    upload_log_file
  end

  private

  attr_reader :run

  def upload_log_file
    return unless File.exist?(log_path)

    run.log_file.attach(
      io: File.open(log_path),
      filename: File.basename(log_path),
    )
  end

  def transition_to_next_state
    run.transition_to!(new_state)
  end

  def log_path
    run.local_log_path
  end

  def new_state
    if run.result_file.attached?
      :succeeded
    else
      :failed
    end
  end
end

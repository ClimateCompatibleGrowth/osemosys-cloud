class AfterFinishHook
  def initialize(run:)
    @run = run
  end

  def call
    transition_to_next_state
    upload_log_file
    log_instance_shutdown
    RunMailer.with(run: run).run_finished_email.deliver_later
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

  def log_instance_shutdown
    return unless run.ec2_instance.present?

    run.ec2_instance.update!(stopped_at: Time.current)
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

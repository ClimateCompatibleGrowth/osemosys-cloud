class AfterFinishHook
  def initialize(run:, log_path:)
    @run = run
    @log_path = log_path
  end

  def call
    run.update_attributes(finished_at: Time.current) if run.finished_at.nil?
    run.log_file.attach(
      io: File.open(log_path),
      filename: File.basename(log_path)
    )
  end

  private

  attr_reader :run, :log_path
end

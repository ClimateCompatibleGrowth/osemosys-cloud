class GenerateResJob < ActiveJob::Base
  queue_as :low_priority
  sidekiq_options retry: 0

  def perform(run_id)
    return if Rails.env.test?

    @run = Run.find(run_id)

    Commands::GenerateRes.new(
      local_data_path: model_and_data.local_data_path,
      res_path: res_path,
      logger: logger,
    ).call
    run.res_file.attach(
      io: File.open("#{res_path}.pdf"),
      filename: File.basename(res_path),
    )
    RefreshRunCard.perform_later(run_id)
  end

  private

  attr_reader :run

  def model_and_data
    @model_and_data ||= Osemosys::DownloadModelFromS3.new(
      run: run,
      logger: logger,
    ).call
  end

  def res_path
    "/tmp/res-#{run.id}"
  end

  def logger
    Logger.new($stdout)
  end
end

class GenerateResJob < ActiveJob::Base
  queue_as :low_priority
  sidekiq_options retry: 0

  def perform(run_id)
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
  end

  private

  attr_reader :run

  def model_and_data
    @model_and_data ||= begin
      if Rails.env.test?
        OpenStruct.new(
          local_model_path: ActiveStorage::Blob.service.send(:path_for, run.model_file.key),
          local_data_path: ActiveStorage::Blob.service.send(:path_for, run.data_file.key),
        )
      else
        Osemosys::DownloadModelFromS3.new(
          run: run,
          logger: logger,
        ).call
      end
    end
  end

  def res_path
    "/tmp/res-#{run.id}"
  end

  def logger
    Logger.new($stdout)
  end
end

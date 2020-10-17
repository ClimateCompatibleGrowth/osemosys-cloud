class GenerateMetadata
  def self.call(*args)
    new(*args).call
  end

  def initialize(run:)
    @run = run
  end

  def call
    File.open(file_path, 'w') do |f|
      f << metadata.to_json
    end

    file_path
  end

  private

  attr_reader :run

  def metadata
    {
      description: run.description,
      model_name: run.model.name,
      run_name: run.name,
      version_name: run.version.name,
    }
  end

  def file_path
    "/tmp/metadata-#{run.id}.json"
  end
end

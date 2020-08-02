require 'rails_helper'

RSpec.describe Osemosys::PrepareResults do
  it 'zips the files and returns the path of the zipped file' do
    output_path = '/tmp/output-test.txt'
    data_path = '/tmp/data-test.txt'
    metadata_path = '/tmp/metadata-test.txt'
    zip_path = '/tmp/test-zip-output.zip'
    unzip_directory = '/tmp/test-zip-directory'
    FileUtils.touch(output_path)
    FileUtils.touch(data_path)
    FileUtils.touch(metadata_path)
    FileUtils.rm_rf(unzip_directory)

    Osemosys::PrepareResults.call(
      output_path: output_path,
      data_path: data_path,
      metadata_path: metadata_path,
      destination: zip_path,
    )

    `unzip -d #{unzip_directory} /tmp/test-zip-output `
    expect(File.exist?("#{unzip_directory}/result.txt")).to be(true)
    expect(File.exist?("#{unzip_directory}/data.txt")).to be(true)
    expect(File.exist?("#{unzip_directory}/metadata.json")).to be(true)
  end
end

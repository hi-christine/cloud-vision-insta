require "google/cloud/storage"
require 'fileutils'

# GCS Ruby Docs: https://googleapis.dev/ruby/google-cloud-storage/latest/
# The BucketFacade class is reliant of google cloud credentials, these were saved off
# at the root of the project as vision-api-user-key.json
# This BucketFacade uses Google Cloud Storage to access the Cloud image files.
class BucketFacade
  attr_reader :project, :credentials, :bucketname, :bucket

  def initialize(project:, credentials:, bucketname:)
    @project = project
    @credentials = credentials
    @bucketname = bucketname

    storage = Google::Cloud::Storage.new(
      project_id: @project,
      credentials: @credentials
    )

    @bucket = storage.bucket @bucketname
  end

  def list_files(prefix, filetype)
    files = @bucket.files prefix: prefix
    if filetype.nil?
      return files
    else
      return files.select { |f| f.name.end_with? filetype }
    end
  end

  def make_gcs_url(gcs_file)
    make_gcs_url_from_path gcs_file.name
  end

  def make_gcs_url_from_path(path)
    "gs://#{bucketname}/#{path}"
  end

  def get_file(gcs_file_path)
    @bucket.file gcs_file_path
  end

  def download_file(gcs_file_path, destination_path)
    @bucket.file(gcs_file_path).download(destination_path)
  end

  def download_file_as_string(gcs_file_path)
    io = StringIO.new
    @bucket.file(gcs_file_path).download(io)
    io.string
  end

  def store_analysis(gcs_file, analysis_type, content)
    file_path = analysis_file_path(gcs_file, analysis_type)
    io = StringIO.new
    io.puts(content)
    @bucket.create_file io, file_path
  end

  def delete_analysis(gcs_file, analysis_type)
    file_path = analysis_file_path(gcs_file, analysis_type)
    @bucket.file(file_path).delete
  end

  def analysis_exists?(gcs_file, analysis_type)
    file_path = analysis_file_path(gcs_file, analysis_type)
    !@bucket.file(file_path).nil?
  end

  def get_analysis(gcs_file, analysis_type)
    file_path = analysis_file_path(gcs_file, analysis_type)
    @bucket.file(file_path)
  end

  def get_all_analysis(prefix)
    list_files(prefix, ".json")
  end

  def download_analysis(prefix, destination_dir)
    FileUtils.mkdir_p destination_dir

    files = get_all_analysis(prefix)
    files.each do |f|
      dest_path = "#{destination_dir}/#{File.basename(f.name)}"
      next if File.file?(dest_path)
      f.download dest_path
      puts "Downloaded #{f.name} to #{dest_path}"
    end
  end

  private

  def analysis_file_path(gcs_file, analysis_type)
    "#{File.dirname(gcs_file.name)}/#{File.basename(gcs_file.name)}.#{analysis_type}.json"
  end
end

DEFAULT_BUCKET = BucketFacade.new(project: 'cloud-vision-api-246317', credentials: './vision-api-user-key.json',
                                  bucketname:  'cloud-vision-instagram')

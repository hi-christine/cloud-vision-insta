require 'rspec'
require_relative '../app/bucket_facade'

# This spec is reliant on the credentials to be set up for the Google Cloud Storage
# for this project they were saved off local to ./vision-api-user-key.json, but we
# won't be sharing our credentials in the gitHub 😉
describe 'GCS Scanner Integration Test' do
  it 'reads files from a prefix' do
    BucketFacade.new(project: 'cloud-vision-api-246317', credentials: './vision-api-user-key.json',
                                               bucketname:  'cloud-vision-instagram').list_files('test', '.jpg')
  end

  it 'makes GCS URLs for files' do
    bucket = BucketFacade.new(project: 'cloud-vision-api-246317', credentials: './vision-api-user-key.json',
                                                 bucketname:  'cloud-vision-instagram')
    files = bucket.list_files('test', '.jpg')
    files.each { |f| puts bucket.make_gcs_url f }
  end

  it 'save analysis' do
    bucket = BucketFacade.new(project: 'cloud-vision-api-246317', credentials: './vision-api-user-key.json',
                                                 bucketname:  'cloud-vision-instagram')
    # Set this filepath to existing bucket folder/jpg, for ex.
    # this image was in the bucket folder 'nike' and was '2011-12-29_cpKnv.jpg'
    filepath = 'nike/2011-12-29_cpKnv.jpg'
    analysis_type = 'rando'
    gcs_file = bucket.get_file filepath
    expect(gcs_file).not_to be_nil
    if bucket.analysis_exists?(gcs_file, analysis_type)
      bucket.delete_analysis(gcs_file, analysis_type)
    end

    bucket.store_analysis(gcs_file, analysis_type, 'some content here')
  end

  analysis_sets = [ "christineseeman", "expertvagabond", "iloveny", "letterfolk", "myraswim",
                    "nationalportraitgallery", "nike", "ripleyandrue", "visit_nebraska", "visitcalifornia", "wolffolins"]

  it "downloads all analysis files" do
    # But you probably don't want to run this all the time so commenting out for now
    # this is an example useage for the download_analysis method
    #
    # bucket = BucketFacade.new(project: 'cloud-vision-api-246317', credentials: './vision-api-user-key.json',
    #                           bucketname:  'cloud-vision-instagram')
    # analysis_sets.each do |a|
    #   bucket.download_analysis("#{a}/", "analysis/#{a}/")
    # end
  end
end

require_relative 'bucket_facade'
require_relative 'auto_ml_training_file'

#bundle exec training_file_generator.rb
bucket_facade = BucketFacade.new(project: "cloud-vision-api-246317",
                                  credentials: "./vision-api-user-key.json",
                                  bucketname:  "cloud-vision-instagram")

outputFile = "./automl.csv"
file = AutoMlTrainingFile.new(outputFile)
analysis_sets = %w[christineseeman expertvagabond iloveny letterfolk myraswim
                  nationalportraitgallery nike ripleyandrue visit_nebraska visitcalifornia wolffolins]
analysis_sets.each do |a|
  files = bucket_facade.list_files a, ".jpg"
  files.each do |f|
    file.addRecord(bucket_facade.make_gcs_url(f), [a])
  end
end

file.close

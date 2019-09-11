
require "google/cloud/vision"
require_relative "bucket_facade"

#https://googleapis.github.io/google-cloud-ruby/docs/

# The ImageAnnotatorClient class uses the BucketFacade to access the stored images
# and provides methods for doing batch analyze on the images.
class ImageAnnotatorClient
  attr_accessor :client

  def initialize
    @client = Google::Cloud::Vision::ImageAnnotator.new(credentials: "./vision-api-user-key.json")
    @bucket_facade = BucketFacade.new(project: "cloud-vision-api-246317",
                                       credentials: "./vision-api-user-key.json",
                                       bucketname:  "cloud-vision-instagram")
  end

  # Public
  # Run a batch analysis on certain folder
  #
  # folder_name = name of the directory with images to analyze
  # file_type = type of file that will be analyzed
  def traverse_folder(folder_name = 'test', file_type = '.jpg', analysis_type = "default")
    files = @bucket_facade.list_files folder_name, file_type

    files.each do |file|
      if analysis_type == "default"
        batch_analyze(file)
      elsif analysis_type == "safe_search"
        batch_analyze(file, :SAFE_SEARCH_DETECTION, :FACE_DETECTION, :LABEL_DETECTION)
      elsif analysis_type =="text_search"
        batch_analyze(file, :TEXT_DETECTION)
      end
    end
  end

  # Public
  # Run an analysis over a whole bucket
  def traverse_bucket
    bucket = @bucket_facade.bucketname
    files = bucket.files delimiter: "/"
    loop do

      files.prefixes.each do |folder|1
      puts "dir: #{folder}"
      traverse_folder folder
      end

      break unless files.next?
      files = files.next
    end
  end

  # Public
  # Delete all the analysis in a certain folder
  def delete_analysis_folder(folder_name = 'test', analysis_type = "FACE_DETECTION_LABEL_DETECTION_LANDMARK_DETECTION_and_LOGO_DETECTION")
    files = @bucket_facade.list_files folder_name, ".jpg"

    files.each do |file|
      if  @bucket_facade.analysis_exists?(file, analysis_type)
        @bucket_facade.delete_analysis(file, analysis_type)
      end
    end
  end

  # Public
  # This will call several of the vision api detection types on a file
  # then will attempt to save off the file in the same location as image
  #
  # file = "gs://" file to have detections run
  # The types of detection that can be done are (and 4 is the max at one time(?)):
  # :LABEL_DETECTION, :FACE_DETECTION, :LANDMARK_DETECTION, :LOGO_DETECTION
  # :TEXT_DETECTION, :SAFE_SEARCH_DETECTION
  def batch_analyze(file, type_1 = :FACE_DETECTION, type_2 = :LABEL_DETECTION, type_3 = :LANDMARK_DETECTION, type_4 = :LOGO_DETECTION)
    gcs_file = file
    gcs_image_uri = @bucket_facade.make_gcs_url gcs_file
    source = { gcs_image_uri: gcs_image_uri }
    image = { source: source }

    features = [{ type: type_1 }, { type: type_2 }, { type: type_3 }, { type: type_4 }]
    requests_element = { image: image, features: features }
    requests = [requests_element]

    response = @client.batch_annotate_images(requests)
    @bucket_facade.store_analysis(gcs_file, "#{type_1.to_s.downcase}_#{type_2.to_s.downcase}_#{type_3.to_s.downcase}_and_#{type_4.to_s.downcase}", response.to_json)
  end

  # Public
  # This method takes a single image file, does face analysis on the image,
  # then prints out the found face annotations. If there are no face annotations found,
  # there will be no output.
  def what_emotion?(file = "expertvagabond/2013-08-10_c17elIPOWV.jpg")
    image_path = @bucket_facade.make_gcs_url_from_path file
    response =  @client.face_detection image: image_path

    response.responses.each do |res|
      res.face_annotations.each do |face|
        puts "Joy:      #{face.joy_likelihood}"
        puts "Anger:    #{face.anger_likelihood}"
        puts "Sorrow:   #{face.sorrow_likelihood}"
        puts "Surprise: #{face.surprise_likelihood}"
      end
    end
  end

  # Public
  # This method takes a single image file, does logo analysis on the image,
  # then prints out the found logo annotations descriptions. If there are no logo annotations found,
  # there will be no output.
  def what_logo?(file = "expertvagabond/2013-08-10_c17elIPOWV.jpg")
    image_path = @bucket_facade.make_gcs_url_from_path file
    response = @client.logo_detection image: image_path

    response.responses.each do |res|
      res.logo_annotations.each do |logo|
        puts logo.description
      end
    end
  end

  # Public
  # This method takes a single image file, does label analysis on the image,
  # then prints out the found labels up to 15. If there are no label annotations found,
  # there will be no output. But frankly Google Cloud Vision always finds labels.
  def what_label?(file = "expertvagabond/2013-08-10_c17elIPOWV.jpg")
    image_path = @bucket_facade.make_gcs_url_from_path file
    response = @client.label_detection(
      image:           image_path,
      max_results:    15 # optional, defaults to 10
    )

    response.responses.each do |res|
      res.label_annotations.each do |label|
        puts label.description
      end
    end
  end

  # Public
  # This method takes a single image file, does safe search detection analysis on the image,
  # then prints out the found safe search annotations. If there are no safe search annotations found,
  # there will be no output.
  def nsfw?(file = "expertvagabond/2013-08-10_c17elIPOWV.jpg")
    image_path = @bucket_facade.make_gcs_url_from_path file

    response = @client.safe_search_detection image: image_path

    response.responses.each do |res|
      safe_search = res.safe_search_annotation

      puts "Adult:    #{safe_search.adult}"
      puts "Spoof:    #{safe_search.spoof}"
      puts "Medical:  #{safe_search.medical}"
      puts "Violence: #{safe_search.violence}"
      puts "Racy:     #{safe_search.racy}"
    end
  end
end

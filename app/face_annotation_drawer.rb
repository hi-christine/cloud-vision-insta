
require_relative 'bucket_facade'
require_relative 'raster_annotator'
require 'tempfile'

# Specify the Google Cloud Bucket image path for drawing the facal annotations
# gs://cloud-vision-instagram/expertvagabond/2014-06-09_pBVtLEPOTE.jpg
image_path = "expertvagabond/2013-08-10_c17elIPOWV.jpg"
# analysis/expertvagabond/2014-06-09_pBVtLEPOTE.jpg.face_detection_label_detection_landmark_detection_and_logo_detection.json
analysis_type = "face_detection_label_detection_landmark_detection_and_logo_detection"
json_path = "#{image_path}.#{analysis_type}.json"
bucket = BucketFacade.new(project: 'cloud-vision-api-246317', credentials: 'vision-api-user-key.json',
                          bucketname:  'cloud-vision-instagram')

downloaded_image = Tempfile.new('image_annotator_jpg')
downloaded_json = Tempfile.new('image_annotator_json')
begin
  gcs_image_file = bucket.get_file(image_path)
  gcs_image_file.download(downloaded_image.path)
  gcs_analysis_file = bucket.get_analysis(gcs_image_file, "label_and_face")

  bucket.download_file(json_path, downloaded_json.path)

  ra = RasterAnnotator.new(downloaded_image.path, "./annotated.jpg")
  json = JSON.parse(File.read(downloaded_json))
  json["responses"][0]["faceAnnotations"].each do |faceAnnotation|
    ra.draw_rect(faceAnnotation["fdBoundingPoly"]["vertices"])
    ra.point_face_landmarks(faceAnnotation)
  end

  ra.save_destination_file
ensure
  downloaded_image.close
  downloaded_image.unlink

  downloaded_json.close
  downloaded_json.unlink
end



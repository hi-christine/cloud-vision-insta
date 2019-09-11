require 'rspec'
require_relative '../app/raster_annotator'

describe 'Raster Annotator' do

  context 'Creating a new RasterAnnotator' do
    it 'can draw a rectangle, point the facial landmarks and save to file' do
      ra = RasterAnnotator.new("./spec/data/expertvagabond.jpg", "./spec/data/annotated.jpg")
      json = JSON.parse(File.read("./spec/data/expertvagabond.json"))
      ra.draw_rect(json["responses"][0]["faceAnnotations"][0]["fdBoundingPoly"]["vertices"])
      ra.point_face_landmarks(json["responses"][0]["faceAnnotations"][0])
      ra.save_destination_file
    end
  end
end

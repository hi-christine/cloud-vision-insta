require_relative 'bucket_facade'
require 'magic_cloud'

class AnalysisReader
  attr_accessor :json

  def initialize(json)
    @json = json
  end

  def has_face_annotations
    @json["responses"][0].key?("faceAnnotations")
  end

  def has_crop_hints_annotations
    @json["responses"][0].key?("cropHintsAnnotation")
  end

  def has_logo_annotations
    @json["responses"][0].key?("logoAnnotations")
  end

  def has_label_annotations
    @json["responses"][0].key?("labelAnnotations")
  end

  def has_landmark_annotations
    @json["responses"][0].key?("landmarkAnnotations")
  end

  def label_annotations
    @json["responses"][0]["labelAnnotations"].map { |l| Annotation.from_hash(l) }
  end

  def explain(prefix = "test/")
    bucket = DEFAULT_BUCKET
    files = bucket.get_all_analysis prefix
    files.each do |f|
      downloaded_json = JSON.parse(bucket.download_file_as_string(f.name))
      response_types = downloaded_json["responses"].flat_map { |r| r.keys }
      puts "#{f.name} has #{downloaded_json["responses"].length} responses with types: #{response_types.uniq}"
    end
  end

  def generate_label_histogram(prefix = "test/")
    histogram = Histogram.new
    bucket = DEFAULT_BUCKET
    files = bucket.get_all_analysis prefix
    files.each do |f|
      downloaded_json = JSON.parse(bucket.download_file_as_string(f.name))
      reader = AnalysisReader.new(downloaded_json)
      if reader.has_label_annotations
        histogram.append_all(reader.label_annotations)
      end
    end

    histogram
  end

  def generate_word_cloud(input_file, output_file)
    # https://github.com/zverok/magic_cloud
    file = File.open(input_file)
    contentArray=[] # start with an empty array
    file.each_line {|line|
      contentArray.push YAML.load(line)
    }
    file.close

    pp contentArray
    cloud = MagicCloud::Cloud.new(contentArray, rotate: :square, scale: :sqrt , font_family: 'Helvetica')
    img = cloud.draw(860, 600)
    img.write('./output/' + output_file)
  end
end

class Annotation
  attr_accessor :description, :score, :topicality

  def self.from_hash(hash)
    Annotation.new(hash["description"], hash["score"], hash["topicality"])
  end

  def initialize(description, score, topicality)
    @description = description
    @score = score
    @topicality = topicality
  end
end

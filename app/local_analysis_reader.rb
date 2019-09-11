require_relative 'bucket_facade'

class LocalAnalysisReader
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

  def logo_annotations
    @json["responses"][0]["logoAnnotations"].map { |l| Annotation.from_hash(l) }
  end

  def landmark_annotations
    @json["responses"][0]["landmarkAnnotations"].reject {|l| l["description"].nil? }
      .map { |l| Annotation.from_hash(l) }
  end

  def explain(prefix = "expertvagabond/")
    responseTypeCounts = {}
    responseTypeCounts.default = 0

    files = Dir["analysis/#{prefix}/*.json"]
    files.each do |f|
      json = JSON.parse(File.read(f))
      json["responses"][0].keys.each do |k|
        responseTypeCounts[k] += 1
      end
    end

    puts "Prefix #{prefix} has #{files.length} files"
    responseTypeCounts.each do |k,v|
      puts "      #{k}: #{v}"
    end
  end

  def explainFaces(prefix = "expertvagabond/")
    files = Dir["analysis/#{prefix}/*.json"]
    files.each do |f|
      json = JSON.parse(File.read(f))
      if LocalAnalysisReader.new(json).has_face_annotations  && json["responses"][0]["faceAnnotations"].length > 1
        puts "#{f} has multiple face annotations"
      end
    end
  end

  def generate_label_histogram(prefix = "expertvagabond/")
    histogram = Histogram.new
    files = Dir["analysis/#{prefix}/*.json"]
    files.each do |f|
      puts "Reading file #{f}"
      json = JSON.parse(File.read(f))
      reader = LocalAnalysisReader.new(json)
      if reader.has_label_annotations
        histogram.append_all(reader.label_annotations)
      end
    end

    histogram
  end

  def generate_logo_histogram(prefix = "expertvagabond/")
    histogram = Histogram.new
    files = Dir["analysis/#{prefix}/*.json"]
    files.each do |f|
      puts "Reading file #{f}"
      json = JSON.parse(File.read(f))
      reader = LocalAnalysisReader.new(json)
      if reader.has_logo_annotations
        histogram.append_all(reader.logo_annotations)
      end
    end

    histogram
  end

  def generate_landmark_histogram(prefix = "expertvagabond/")
    histogram = Histogram.new
    files = Dir["analysis/#{prefix}/*.json"]
    files.each do |f|
      puts "Reading file #{f}"
      json = JSON.parse(File.read(f))
      reader = LocalAnalysisReader.new(json)
      if reader.has_landmark_annotations
        histogram.append_all(reader.landmark_annotations)
      end
    end

    histogram
  end

  def generate_landmark_coordinates(output, prefix = "expertvagabond/")
    files = Dir["analysis/#{prefix}/*.json"]
    out = open(output, 'w')
    out.puts("Landmark,lat,long,score,link")

    files.each do |f|
      puts "Reading file #{f}"
      json = JSON.parse(File.read(f))
      reader = LocalAnalysisReader.new(json)
      if reader.has_landmark_annotations
        landmarks = reader.landmark_annotations
        landmarks.each do |l|
          basename = File.basename(f)
          m = basename.match /(.*\.jpg).*/
          image_link = "https://storage.googleapis.com/cloud-vision-instagram/#{prefix}/#{m[1]}"
          out.puts "\"#{l.description}\",#{l.lat},#{l.long},#{l.score},#{image_link}"
        end
      end
    end
    out.close
  end
end

class Annotation
  attr_accessor :description, :score, :topicality, :lat, :long

  def self.from_hash(hash)
    result = Annotation.new(hash["description"], hash["score"], hash["topicality"])
    result.record_location hash["locations"][0]["latLng"] if hash.key? "locations"
    result
  end

  def initialize(description, score, topicality)
    @description = description
    @score = score
    @topicality = topicality
  end

  def record_location(lat_long)
    @lat = lat_long["latitude"]
    @long = lat_long["longitude"]
  end
end

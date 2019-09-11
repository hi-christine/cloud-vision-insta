require 'rspec'
require_relative '../app/analysis_reader'
require_relative '../app/local_analysis_reader'
require_relative '../app/histogram'

describe 'AnalysisReader' do
  context 'runs explain' do

    analysis_sets = [ "christineseeman", "expertvagabond", "iloveny", "letterfolk", "myraswim",
                      "nationalportraitgallery", "nike", "ripleyandrue", "visit_nebraska", "visitcalifornia", "wolffolins"]

    it "generates a histogram for all analysis for test" do
      AnalysisReader.new('').generate_label_histogram
    end

    it "generates a histogram for all analysis for nike" do
      # But probably don't want to run it all the time.
      # AnalysisReader.new('').generate_label_histogram("nike/")
    end

    it "generates a histogram for all analysis for christineseeman" do
      histogram = AnalysisReader.new('').generate_label_histogram("christineseeman/")
      File.write("./output/#{prefix}_labels.json", histogram.to_json)
    end

    it "generates a histogram for all analysis for iloveny" do
      histogram = AnalysisReader.new('').generate_label_histogram("iloveny/")
    end

    it "generates a histogram for all analysis for letterfolk" do
      histogram = AnalysisReader.new('').generate_label_histogram("letterfolk/")
    end

    it "generates a wordcloud from local histogram analysis" do
      AnalysisReader.new('').generate_word_cloud('./output/test.histogram', 'test.png')
    end

    it "generates a label histogram for all local analysis seta" do
      analysis_sets.each do |a|
        histogram = LocalAnalysisReader.new('').generate_label_histogram(a)
        File.write("./output/#{a}_labels.json", histogram.sorted_results)
      end
    end

    it "generates a logo histogram for all local analysis sets" do
      analysis_sets.each do |a|
        histogram = LocalAnalysisReader.new('').generate_logo_histogram(a)
        File.write("./output/#{a}_logos.json", histogram.sorted_results)
      end
    end

    it "generates a landmark histogram for all local analysis sets" do
      analysis_sets.each do |a|
        histogram = LocalAnalysisReader.new('').generate_landmark_histogram(a)
        File.write("./output/#{a}_landmarks.json", histogram.sorted_results)
      end
    end

    it "runs explain on an analysis set" do
      analysis_sets.each do |a|
        LocalAnalysisReader.new('').explain a
      end
    end

    it "runs explainFaces on an analysis set" do
      LocalAnalysisReader.new('').explainFaces("expertvagabond")
    end

    it "generates a landmark coordinate csv for expertvagabond" do
      LocalAnalysisReader.new('').generate_landmark_coordinates("output/expertvagabond.csv", "expertvagabond")
    end

    it "generates a landmark coordinate csv for iloveny" do
      LocalAnalysisReader.new('').generate_landmark_coordinates("output/iloveny.csv", "iloveny")
    end

    it "generates a landmark coordinate csv for visit_nebraska" do
      LocalAnalysisReader.new('').generate_landmark_coordinates("output/visit_nebraska.csv", "visit_nebraska")
    end

    it "generates a landmark coordinate csv for visitcalifornia" do
      LocalAnalysisReader.new('').generate_landmark_coordinates("output/visitcalifornia.csv", "visitcalifornia")
    end
  end
end


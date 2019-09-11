require 'rspec'
require_relative '../app/../app/image_annotator_client'

describe ImageAnnotatorClient do

  it { should respond_to :batch_analyze }
  it { should respond_to :what_emotion? }
  it { should respond_to :what_logo? }
  it { should respond_to :what_label? }
  it { should respond_to :traverse_folder }
  it { should respond_to :traverse_bucket }

  context 'when creating a client' do
    it 'creates an image annotator client' do
      expect(described_class.new).to_not be_nil
    end
  end

  context 'when looking for a face on a picture' do
    it 'can tell me the likelhood of an emotion' do
      expect(described_class.new.what_emotion?).to_not be_nil
    end
  end

  context 'when looking for content in an image' do
    it 'can tell me if there is racy or other content' do
      expect(described_class.new.nsfw?).to_not be_nil
    end
  end

  context 'when trying to batch analyze files' do
    it 'can read a bunch and save output' do
      # Need a better way of mocking a gcs file now
      # Probably shouldn't have to point at a real file.
      # response = described_class.new.batch_analyze test
      # expect(response).to_not be_nil
    end
  end

  it 'can analyze a whole folder in the cloud bucket' do
    response = described_class.new.traverse_folder("test")
    expect(response).to_not be_nil
  end
end

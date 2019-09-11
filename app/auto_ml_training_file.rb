class AutoMlTrainingFile
  attr_reader :csvFilePath

  def initialize(outputFile)
    @outputFile = File.open(outputFile, 'w')
  end

  def addRecord(gssUrl, tagArray)
    @outputFile.write("#{gssUrl},#{tagArray.join(",")}\n")
  end

  def close
    @outputFile.close
  end
end

require "logger"

module VisonLogger
  LOGGER = Logger.new $stderr, level: Logger::DEBUG
  def logger
    LOGGER
  end
end

# Define a gRPC module-level logger method before grpc/logconfig.rb loads.
module GRPC
  extend VisonLogger
end

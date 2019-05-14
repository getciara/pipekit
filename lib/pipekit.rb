
require "active_support/core_ext/hash"
require "httparty"
require "hashie"
require "pipekit/version"
require "pipekit/client"

module Pipekit
  class Error < StandardError; end
  class UnauthorizedError < Error; end
  class ConnectionError < Error; end
  class ForbiddenError < Error; end
  class LimitError < Error; end

  class << self
    def client
      return @client if defined?(@client)
      @client = Pipekit::Client.new(options)
    end
  end
end

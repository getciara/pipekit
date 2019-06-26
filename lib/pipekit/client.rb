require "pipekit/client/connection"

require "pipekit/client/people"
require "pipekit/client/activities"
require "pipekit/client/deals"

module Pipekit
  class Client
    include HTTParty
    include Pipekit::Client::Connection
    include Pipekit::Client::People
    include Pipekit::Client::Activities
    include Pipekit::Client::Deals

    base_uri "https://api-proxy.pipedrive.com"
    format :json

    query_string_normalizer proc { |query|
      query.map do |key, value|
        if value.is_a?(Array)
          value.map {|v| "#{key}=#{v}"}
        else
          {key => value}.to_query
        end
      end.flatten.sort.join('&')
    }

    def initialize(options = {})
      # Loop through potential options. Can be extended to set default values.
      %w(oauth_token token_expires_in refresh_token client_id client_secret authentication_callback).each do |key|
        value = options.has_key?(key.to_sym) ? options[key.to_sym] : nil
        instance_variable_set(:"@#{key}", value) if value
      end

      self.class.default_options.merge!(
        headers: {
          'Authorization' => "Bearer #{@oauth_token}"
        }
      )
    end

    def oauth_token=(value)
      @oauth_token = value
      self.class.default_options.merge!(headers: { 'Authorization' => "Bearer #{@oauth_token}" })
    end

    def token_expires_in=(value)
      @token_expires_in = value
    end
  end
end

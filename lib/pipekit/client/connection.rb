module Pipekit
  class Client
    module Connection
      def get(path, options = {})
        request :get, path, options
      end

      def post(path, options = {})
        options[:headers] ||= {}
        options[:headers].merge!({ 'Content-Type' => 'application/json' })
        request :post, path, options
      end

      def put(path, options = {})
        options[:headers] ||= {}
        options[:headers].merge!({ 'Content-Type' => 'application/json' })
        request :put, path, options
      end

      private

      def request(http_method, path, options)
        retries = 2
        begin
          response = call(http_method, path, options)
          case response.parsed_response
            when Hash then Hashie::Mash.new(response.parsed_response)
            when Array then response.parsed_response.map {|hash| Hashie::Mash.new(hash) }
            when nil then nil
            else response.parsed_response
          end
        rescue Pipekit::UnauthorizedError
          if retries.positive?
            retries -= 1
            retry
          end
          raise
        end

      end

      def call(http_method, path, options)
        response = self.class.send(http_method, path, options)

        case response.code
          when 200..204
            return response
          when 401
            authenticate!
            raise Pipekit::UnauthorizedError
          when 403
            raise Pipekit::ForbiddenError
          when 429
            raise Pipekit::LimitError
          when 522
            raise Pipekit::ConnectionError
          else
            begin
              parsed_error = response.parsed_response['message']
            rescue JSON::ParserError
              parsed_error = response.to_s
            end
            raise Pipekit::Error, parsed_error
          end
      end

      def authenticate!
        self.oauth_token = nil

        response = self.class.post('https://oauth.pipedrive.com/oauth/token', body: {
          grant_type: 'refresh_token',
          client_id: @client_id,
          client_secret: @client_secret,
          refresh_token: @refresh_token
        })

        if response.code != 200
          begin
            parsed_error = response.parsed_response['message']
          rescue JSON::ParserError
            parsed_error = response.to_s
          end
          raise Pipekit::Error, parsed_error
        end

        data = Hashie::Mash.new(response.parsed_response)

        self.oauth_token = data.access_token
        self.token_expires_in = data.expires_in

        @authentication_callback&.call(data)
        data
      end
    end
  end
end

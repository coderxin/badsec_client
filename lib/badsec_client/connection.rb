# frozen_string_literal: true

require 'faraday'

module BadsecClient
  class RetryError < StandardError; end
  class MaxRetryExceededError < StandardError; end

  class Connection
    HTTP_STATUS_OK = 200

    HTTP_RESP_ACCESS_TOKEN = 'badsec-authentication-token'
    HTTP_REQ_CHECKSUM = 'X-Request-Checksum'

    AUTHENTICATION_PATH = 'auth'

    attr_reader :access_token

    def initialize(config)
      @config = config
      @access_token = nil
    end

    def authenticated?
      !access_token.nil?
    end

    def authenticate!
      response = with_retry! { Faraday.head(url_for(AUTHENTICATION_PATH)) }
      @access_token = response.headers[HTTP_RESP_ACCESS_TOKEN]
      response
    end

    def get(resource_name:, request_checksum:)
      with_retry! do
        http_headers = request_checksum ? { HTTP_REQ_CHECKSUM => request_checksum } : {}
        Faraday.get(url_for(resource_name), {}, http_headers)
      end
    end

    private

    attr_reader :config

    def url_for(resource_name)
      "http://#{config.host}/#{resource_name}"
    end

    def with_retry!
      retry_attempts = 0

      begin
        retry_attempts += 1
        response = yield

        if response.status == HTTP_STATUS_OK
          response
        elsif retry_attempts > config.max_failure_retry_attempts
          raise MaxRetryExceededError, 'Max retry threshold reached'
        else
          raise RetryError, response.body
        end
      rescue RetryError
        retry
      rescue Faraday::ConnectionFailed => e
        if retry_attempts > config.max_failure_retry_attempts
          raise MaxRetryExceededError, "Max retry threshold reached due to: \"#{e}\" error"
        end

        retry
      end
    end
  end
end

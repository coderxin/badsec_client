# frozen_string_literal: true

module BadsecClient
  class AuthenticationError < StandardError; end

  class Client
    def initialize(config = Config.new)
      @connection = Connection.new(config)
    end

    def authenticate!
      connection.authenticate! unless connection.authenticated?
      connection
    end

    def users
      unless connection.authenticated?
        raise AuthenticationError, 'Please #authenticate! first to obtain the access_token'
      end

      Resources::User.new(connection)
    end

    private

    attr_reader :connection
  end
end

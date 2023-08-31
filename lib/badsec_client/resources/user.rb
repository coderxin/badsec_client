# frozen_string_literal: true

require 'digest'

module BadsecClient
  module Resources
    class User
      def initialize(connection)
        @connection = connection
      end

      def list
        response = connection.get(resource_name:, request_checksum:)
        response.body.split("\n")
      end

      private

      attr_reader :connection

      def resource_name
        'users'
      end

      def request_checksum
        Digest::SHA256.hexdigest("#{connection.access_token}/#{resource_name}")
      end
    end
  end
end

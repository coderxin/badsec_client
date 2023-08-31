# frozen_string_literal: true

require_relative 'badsec_client/version'

require_relative 'badsec_client/client'
require_relative 'badsec_client/config'
require_relative 'badsec_client/connection'
require_relative 'badsec_client/resources/user'
require_relative 'badsec_client/formatters/json'

module BadsecClient
  class << self
    def run
      client = Client.new
      client.authenticate!

      users_resource = client.users
      print Formatters::Json.format(users_resource.list)
    rescue MaxRetryExceededError => e
      print e
      exit 1
    end
  end
end

# frozen_string_literal: true

module BadsecClient
  class Config
    DEFAULT_HOST = 'localhost:8888'
    DEFAULT_MAX_FAILURE_RETRIES = 2

    attr_reader :host, :max_failure_retry_attempts

    # FIXME: make me configurable (allow override of the defaults)

    def initialize
      @host = DEFAULT_HOST
      @max_failure_retry_attempts = DEFAULT_MAX_FAILURE_RETRIES
    end
  end
end

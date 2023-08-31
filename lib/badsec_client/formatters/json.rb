# frozen_string_literal: true

require 'json'

module BadsecClient
  module Formatters
    class Json
      class << self
        def format(input)
          JSON.dump(input)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Retrieve
  module TestingSupport
    ##
    # JSON helpers for testing
    #
    module JsonHelpers
      def json_response
        @json_response ||= JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Retrieve::TestingSupport::JsonHelpers, type: :request
end

# frozen_string_literal: true

module Toller
  module Filters
    ##
    # Where handler for filter
    #
    class WhereHandler
      def call(collection, value, properties)
        field_name = properties[:field]

        collection.where(field_name => value)
      end
    end
  end
end

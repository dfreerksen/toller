# frozen_string_literal: true

module Toller
  module Sorts
    ##
    # Order handler for filter
    #
    class OrderHandler
      def call(collection, direction, properties)
        field_name = properties[:field]

        collection.order(field_name => direction)
      end
    end
  end
end

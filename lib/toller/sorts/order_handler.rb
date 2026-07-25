# frozen_string_literal: true

module Toller
  # :nodoc:
  module Sorts
    ##
    # Order handler for filter
    class OrderHandler
      ##
      # Applies a plain `order` clause to +collection+ for a non-scope sort.
      #
      # @param collection [ActiveRecord::Relation] the collection to sort
      # @param direction [Symbol] the sort direction, :asc or :desc
      # @param properties [Hash] the sort's properties, used to resolve `:field`
      # @return [ActiveRecord::Relation] the sorted collection
      def call(collection, direction, properties)
        field_name = properties[:field]

        collection.order(field_name => direction)
      end
    end
  end
end

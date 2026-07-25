# frozen_string_literal: true

module Toller
  # :nodoc:
  module Filters
    ##
    # Scope handler for filter
    class ScopeHandler
      ##
      # Applies a named scope to +collection+ for a `type: :scope` filter.
      #
      # @param collection [ActiveRecord::Relation] the collection to filter
      # @param value [Object] the filter param value to pass to the scope
      # @param properties [Hash] the filter's properties, used to resolve `:scope_name` (falling back to `:field`)
      # @return [ActiveRecord::Relation] the scoped collection
      def call(collection, value, properties)
        scoped_name = properties[:scope_name] || properties[:field]

        collection.public_send(scoped_name, value)
      end
    end
  end
end

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
      # If the resolved scope doesn't exist on the collection's model, the
      # filter is logged and skipped instead of raising a NoMethodError.
      #
      # @param collection [ActiveRecord::Relation] the collection to filter
      # @param value [Object] the filter param value to pass to the scope
      # @param properties [Hash] the filter's properties, used to resolve `:scope_name` (falling back to `:field`)
      # @return [ActiveRecord::Relation] the scoped collection, or +collection+ unchanged if the scope is unknown
      def call(collection, value, properties)
        scoped_name = properties[:scope_name] || properties[:field]

        unless collection.klass.respond_to?(scoped_name)
          Rails.logger.warn("[Toller] Skipping filter: #{collection.klass} has no scope `#{scoped_name}`")
          return collection
        end

        collection.public_send(scoped_name, value)
      end
    end
  end
end

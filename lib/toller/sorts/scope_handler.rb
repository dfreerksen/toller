# frozen_string_literal: true

module Toller
  # :nodoc:
  module Sorts
    ##
    # Scope handler for sort
    class ScopeHandler
      ##
      # Applies a named scope to +collection+ for a `type: :scope` sort.
      #
      # If the resolved scope doesn't exist on the collection's model, the
      # sort is logged and skipped instead of raising a NoMethodError.
      #
      # @param collection [ActiveRecord::Relation] the collection to sort
      # @param direction [Symbol] the sort direction, :asc or :desc, passed to the scope
      # @param properties [Hash] the sort's properties, used to resolve `:scope_name` (falling back to `:field`)
      # @return [ActiveRecord::Relation] the scoped collection, or +collection+ unchanged if the scope is unknown
      def call(collection, direction, properties)
        scoped_name = properties[:scope_name] || properties[:field]

        unless collection.klass.respond_to?(scoped_name)
          Rails.logger.warn("[Toller] Skipping sort: #{collection.klass} has no scope `#{scoped_name}`")
          return collection
        end

        collection.public_send(scoped_name, direction)
      end
    end
  end
end

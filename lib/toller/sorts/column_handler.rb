# frozen_string_literal: true

module Toller
  # :nodoc:
  module Sorts
    ##
    # Column handler for filter
    class ColumnHandler
      ##
      # Applies a plain `order` clause to +collection+ for a non-scope sort.
      #
      # If +field+ isn't a real column on the collection's model, the sort is
      # logged and skipped instead of raising once the relation is evaluated.
      #
      # @param collection [ActiveRecord::Relation] the collection to sort
      # @param direction [Symbol] the sort direction, :asc or :desc
      # @param properties [Hash] the sort's properties, used to resolve `:field`
      # @return [ActiveRecord::Relation] the sorted collection, or +collection+ unchanged if `:field` is unknown
      def call(collection, direction, properties)
        field_name = properties[:field]

        unless collection.klass.column_names.include?(field_name.to_s)
          Rails.logger.warn("[Toller] Skipping sort: #{collection.klass} has no column `#{field_name}`")
          return collection
        end

        collection.order(field_name => direction)
      end
    end
  end
end

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
      # If +field+ isn't a real column on the collection's model, or the column's actual type
      # doesn't match the declared `type:`, the sort is logged and skipped instead of raising
      # once the relation is evaluated.
      #
      # @param collection [ActiveRecord::Relation] the collection to sort
      # @param type [Symbol] the sort type (e.g. :string, :integer, :boolean)
      # @param direction [Symbol] the sort direction, :asc or :desc
      # @param properties [Hash] the sort's properties, used to resolve `:field`
      # @return [ActiveRecord::Relation] the sorted collection, or +collection+ unchanged if `:field` is
      #                                  unknown or its actual column type doesn't match `type`
      def call(collection, type, direction, properties)
        field_name = properties[:field]

        return collection unless resolvable_column?(collection, field_name, type)

        collection.order(field_name => direction)
      end

      private

      ##
      # Confirms +field_name+ is a real column on +collection+'s model whose actual type matches
      # +type+, logging a warning and returning false otherwise.
      #
      # @param collection [ActiveRecord::Relation] the collection to sort
      # @param field_name [Symbol] the column to look up
      # @param type [Symbol] the sort's declared type
      # @return [Boolean] whether +field_name+ exists and its actual column type matches +type+
      def resolvable_column?(collection, field_name, type)
        unless collection.klass.column_names.include?(field_name.to_s)
          Rails.logger.warn("[Toller] Skipping sort: #{collection.klass} has no column `#{field_name}`")
          return false
        end

        actual_type = collection.klass.columns_hash[field_name.to_s].type
        return true if actual_type == type

        Rails.logger.warn(
          "[Toller] Skipping sort: #{collection.klass}##{field_name} is `#{actual_type}`, declared as `#{type}`"
        )
        false
      end
    end
  end
end

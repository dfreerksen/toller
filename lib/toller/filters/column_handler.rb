# frozen_string_literal: true

module Toller
  # :nodoc:
  module Filters
    ##
    # Column handler for filter
    class ColumnHandler
      ##
      # Applies a plain `where` clause to +collection+ for a non-scope filter.
      #
      # If +field+ isn't a real column on the collection's model, or the column's actual type
      # doesn't match the declared `type:`, the filter is logged and skipped instead of raising
      # (or silently applying a mismatched mutator) once the relation is evaluated.
      #
      # @param collection [ActiveRecord::Relation] the collection to filter
      # @param type [Symbol] the filter type (e.g. :string, :integer, :boolean)
      # @param value [Object] the raw filter param value
      # @param properties [Hash] the filter's properties, used to resolve `:field`
      # @return [ActiveRecord::Relation] the filtered collection, or +collection+ unchanged if `:field` is
      #                                  unknown or its actual column type doesn't match `type`
      def call(collection, type, value, properties)
        field_name = properties[:field]

        return collection unless resolvable_column?(collection, field_name, type)

        mutated_value = value_mutator(type, value)

        collection.where(field_name => mutated_value)
      end

      private

      ##
      # Confirms +field_name+ is a real column on +collection+'s model whose actual type matches
      # +type+, logging a warning and returning false otherwise.
      #
      # @param collection [ActiveRecord::Relation] the collection to filter
      # @param field_name [Symbol] the column to look up
      # @param type [Symbol] the filter's declared type
      # @return [Boolean] whether +field_name+ exists and its actual column type matches +type+
      def resolvable_column?(collection, field_name, type)
        unless collection.klass.column_names.include?(field_name.to_s)
          Rails.logger.warn("[Toller] Skipping filter: #{collection.klass} has no column `#{field_name}`")
          return false
        end

        actual_type = collection.klass.columns_hash[field_name.to_s].type
        return true if actual_type == type

        Rails.logger.warn(
          "[Toller] Skipping filter: #{collection.klass}##{field_name} is `#{actual_type}`, declared as `#{type}`"
        )
        false
      end

      ##
      # Value mutator
      #
      # Runs +value+ through the type-specific mutator, if one exists for +type+.
      #
      # @param type [Symbol] the filter type
      # @param value [Object] the raw filter param value
      # @return [Object] the mutated value, or the original +value+ if +type+ has no mutator
      def value_mutator(type, value)
        return value unless %i[boolean date datetime integer time].include?(type)

        send("#{type}_mutator", value)
      end

      ##
      # Boolean mutator
      #
      # @param value [String] the raw filter param value
      # @return [Boolean] the mutated boolean value
      def boolean_mutator(value)
        Mutators::Boolean.call(value)
      end

      ##
      # Integer mutator
      #
      # @param value [String] the raw filter param value
      # @return [String, Range] the mutated integer value or range
      def integer_mutator(value)
        Mutators::Integer.call(value)
      end

      ##
      # Date mutator
      #
      # @param value [String] the raw filter param value
      # @return [String, Range] the mutated date value or range
      def date_mutator(value)
        Mutators::Date.call(value)
      end

      ##
      # Time mutator
      #
      # @param value [String] the raw filter param value
      # @return [String, Range] the mutated time value or range
      def time_mutator(value)
        Mutators::Time.call(value)
      end

      ##
      # DateTime mutator
      #
      # @param value [String] the raw filter param value
      # @return [String, Range] the mutated datetime value or range
      def datetime_mutator(value)
        Mutators::Datetime.call(value)
      end
    end
  end
end

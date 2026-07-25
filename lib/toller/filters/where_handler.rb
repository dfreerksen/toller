# frozen_string_literal: true

module Toller
  # :nodoc:
  module Filters
    ##
    # Where handler for filter
    class WhereHandler
      ##
      # Applies a plain `where` clause to +collection+ for a non-scope filter.
      #
      # @param collection [ActiveRecord::Relation] the collection to filter
      # @param type [Symbol] the filter type (e.g. :string, :integer, :boolean)
      # @param value [Object] the raw filter param value
      # @param properties [Hash] the filter's properties, used to resolve `:field`
      # @return [ActiveRecord::Relation] the filtered collection
      def call(collection, type, value, properties)
        field_name = properties[:field]

        mutated_value = value_mutator(type, value)

        collection.where(field_name => mutated_value)
      end

      private

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

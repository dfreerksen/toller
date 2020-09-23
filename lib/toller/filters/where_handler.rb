# frozen_string_literal: true

module Toller
  module Filters
    ##
    # Where handler for filter
    #
    class WhereHandler
      def call(collection, type, value, properties)
        field_name = properties[:field]

        mutated_value = value_mutator(type, value)

        collection.where(field_name => mutated_value)
      end

      private

      def value_mutator(type, value)
        return value unless %i[boolean date datetime integer jsonb time].include?(type)

        send("#{type}_mutator", value)
      end

      def boolean_mutator(value)
        Mutators::Boolean.call(value)
      end

      def integer_mutator(value)
        Mutators::Integer.call(value)
      end

      def date_mutator(value)
        Mutators::Date.call(value)
      end

      def time_mutator(value)
        Mutators::Time.call(value)
      end

      def datetime_mutator(value)
        Mutators::Datetime.call(value)
      end

      def jsonb_mutator(value)
        Mutators::Jsonb.call(value)
      end
    end
  end
end

# frozen_string_literal: true

module Toller
  # :nodoc:
  module Filters
    # :nodoc:
    module Mutators
      ##
      # Integer filter mutator
      module Integer
        module_function

        ##
        # Coerces a raw filter param into an integer value or range.
        #
        # @param value [String] the raw filter param value
        # @return [String, Range] the original value, or a Range when the value contains range syntax (`..` or `...`)
        def call(value)
          return value unless range?(value)

          range(value)
        end

        ##
        # Checks whether +value+ contains range syntax.
        #
        # @param value [String] the raw filter param value
        # @return [Boolean] true if +value+ contains `..` or `...`
        def range?(value)
          range_dots = inclusive_or_exclusive_range(value)

          range_dots.present?
        end

        ##
        # Builds a Range by splitting +value+ on its range dots.
        #
        # @param value [String] the raw range string, e.g. "1..10"
        # @return [Range] the resulting range
        def range(value)
          Range.new(*value.split(inclusive_or_exclusive_range(value)))
        end

        ##
        # Detects whether +value+ contains inclusive or exclusive range syntax.
        #
        # @param value [String] the raw filter param value
        # @return [String,nil] "..." for an exclusive range, ".." for an inclusive range, or nil if +value+ is not
        #                      a range
        def inclusive_or_exclusive_range(value)
          return "..." if value.include?("...")
          return ".." if value.include?("..")

          nil
        end
      end
    end
  end
end

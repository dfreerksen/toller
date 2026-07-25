# frozen_string_literal: true

module Toller
  # :nodoc:
  module Filters
    # :nodoc:
    module Mutators
      ##
      # Time filter mutator
      module Time
        module_function

        ##
        # Coerces a raw filter param into a time value or range.
        #
        # @param value [String] the raw filter param value
        # @return [String,Range] the original value, or a Range when the value contains range syntax (`..` or `...`)
        def call(value)
          range_dots = inclusive_or_exclusive_range(value)

          return value if range_dots.blank?

          range(value, range_dots)
        end

        ##
        # Builds a Range by splitting +value+ on the given range dots.
        #
        # @param value [String] the raw range string, e.g. "09:00..17:00"
        # @param dots [String] the range separator, either ".." or "..."
        # @return [Range] the resulting range
        def range(value, dots)
          Range.new(*value.split(dots))
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

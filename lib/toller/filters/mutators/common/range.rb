# frozen_string_literal: true

module Toller
  # :nodoc:
  module Filters
    # :nodoc:
    module Mutators
      # :nodoc:
      module Common
        ##
        # Shared range-parsing behavior for filter mutators. Extend this module to get a
        # `call(value)` that returns +value+ unchanged, or a Range when +value+ contains
        # Ruby range syntax (`..` for inclusive, `...` for exclusive).
        #
        # Methods here must refer to Ruby's core Range class as `::Range` - a bare
        # `Range` would resolve to this module (Mutators::Common::Range) instead, since
        # Ruby's constant lookup checks the lexical scope before the top level.
        module Range
          ##
          # Coerces a raw filter param into its original value or a Range.
          #
          # @param value [String] the raw filter param value
          # @return [String,::Range] the original value, or a Range when the value contains range syntax
          #                          (`..` or `...`)
          def call(value)
            range_dots = inclusive_or_exclusive_range(value)

            return value if range_dots.blank?

            range(value, range_dots)
          end

          ##
          # Builds a Range by splitting +value+ on the given range dots.
          #
          # @param value [String] the raw range string, e.g. "1..10"
          # @param dots [String] the range separator, either ".." or "..."
          # @return [::Range] the resulting range, exclusive when +dots+ is "..."
          def range(value, dots)
            ::Range.new(*value.split(dots), dots == "...")
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
end

# frozen_string_literal: true

module Toller
  module Filters
    module Mutators
      ##
      # Datetime filter mutator
      #
      module Datetime
        module_function

        def call(value)
          range_dots = inclusive_or_exclusive_range(value)

          return value if range_dots.blank?

          range(value, range_dots)
        end

        def range(value, dots)
          Range.new(*value.split(dots))
        end

        def inclusive_or_exclusive_range(value)
          return '...' if value.include?('...')
          return '..' if value.include?('..')

          nil
        end
      end
    end
  end
end

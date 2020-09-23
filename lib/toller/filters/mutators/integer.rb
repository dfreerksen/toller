# frozen_string_literal: true

module Toller
  module Filters
    module Mutators
      ##
      # Integer filter mutator
      #
      module Integer
        module_function

        def call(value)
          return value unless range?(value)

          range(value)
        end

        def range?(value)
          range_dots = inclusive_or_exclusive_range(value)

          range_dots.present?
        end

        def range(value)
          Range.new(*value.split(inclusive_or_exclusive_range(value)))
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

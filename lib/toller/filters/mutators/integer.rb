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
          if range?(value)
            range(value)
          else
            value
          end
        end

        def range?(value)
          value.include?('..')
        end

        def range(value)
          Range.new(*value.split('..'))
        end
      end
    end
  end
end

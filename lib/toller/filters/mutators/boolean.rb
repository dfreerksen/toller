# frozen_string_literal: true

module Toller
  module Filters
    module Mutators
      ##
      # Boolean filter mutator
      #
      module Boolean
        module_function

        def call(value)
          %w[1 t true y yes].include?(value)
        end
      end
    end
  end
end

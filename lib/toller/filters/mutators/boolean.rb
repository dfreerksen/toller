# frozen_string_literal: true

module Toller
  # :nodoc:
  module Filters
    # :nodoc:
    module Mutators
      ##
      # Boolean filter mutator
      module Boolean
        module_function

        ##
        # Coerces a raw filter param into a boolean.
        #
        # @param value [String] the raw filter param value
        # @return [Boolean] true if +value+ is one of "1", "t", "true", "y", "yes"; false otherwise
        def call(value)
          %w[1 t true y yes].include?(value.to_s.downcase)
        end
      end
    end
  end
end

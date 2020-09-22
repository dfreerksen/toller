# frozen_string_literal: true

module Toller
  module Sorts
    ##
    # Scope handler for sort
    #
    class ScopeHandler
      def call(collection, direction, properties)
        scoped_name = properties[:scope_name] || properties[:field]

        collection.public_send(scoped_name, direction)
      end
    end
  end
end

# frozen_string_literal: true

module Toller
  module Filters
    ##
    # Scope handler for filter
    #
    class ScopeHandler
      def call(collection, value, properties)
        scoped_name = properties[:scope_name] || properties[:field]

        collection.public_send(scoped_name, value)
      end
    end
  end
end

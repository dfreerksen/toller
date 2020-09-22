# frozen_string_literal: true

module Toller
  ##
  # Sort
  #
  class Sort
    attr_reader :parameter, :properties, :type

    def initialize(parameter, type, options)
      @parameter = parameter
      @type = type
      @properties = options.reverse_merge(
        field: parameter,
        default: false,
        scope_name: nil
      )
    end

    def apply!(collection, direction = :asc)
      if type == :scope
        Sorts::ScopeHandler.new.call(collection, direction, properties)
      else
        Sorts::OrderHandler.new.call(collection, direction, properties)
      end
    end

    def default
      properties[:default]
    end
  end
end

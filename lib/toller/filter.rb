# frozen_string_literal: true

module Toller
  ##
  # Filter
  #
  class Filter
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

    def apply!(collection, value)
      if type == :scope
        Filters::ScopeHandler.new.call(collection, value, properties)
      else
        Filters::WhereHandler.new.call(collection, type, value, properties)
      end
    end

    def default
      properties[:default]
    end
  end
end

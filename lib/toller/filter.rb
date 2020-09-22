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
        scoped_name = properties[:scope_name] || properties[:field]

        collection.public_send(scoped_name, value)
      else
        field_name = properties[:field]

        collection.where(field_name => value)
      end
    end

    def default
      properties[:default]
    end
  end
end

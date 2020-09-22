# frozen_string_literal: true

module Retrieve
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
        scoped_name = properties[:scope_name] || properties[:field]

        collection.public_send(scoped_name, direction)
      else
        field_name = properties[:field]

        collection.order(field_name => direction)
      end
    end

    def default
      properties[:default]
    end
  end
end

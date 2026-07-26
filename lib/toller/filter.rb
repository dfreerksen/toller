# frozen_string_literal: true

module Toller
  ##
  # Filter
  class Filter
    # @return [Symbol] the public filter param name
    attr_reader :parameter

    # @return [Hash] the filter's resolved options (:field, :default, :scope_name, etc.)
    attr_reader :properties

    # @return [Symbol] the filter type, e.g. :string, :integer, :scope
    attr_reader :type

    ##
    # @param parameter [Symbol] the public filter param name
    # @param type [Symbol] the filter type, e.g. :string, :integer, :scope
    # @param options [Hash] filter options; merged over defaults for :field, :default, and :scope_name
    # @option options [Symbol] :field the column/attribute to query; defaults to +parameter+
    # @option options [Boolean] :default whether this filter applies automatically when no filter params were sent
    # @option options [Symbol] :scope_name for type: :scope, the model scope to call; defaults to +parameter+
    # @return [Toller::Filter] a new instance of Filter
    # @raise [ArgumentError] if +type+ isn't one of {Toller::VALID_TYPES}
    def initialize(parameter, type, options)
      validate_type!(parameter, type)

      @parameter = parameter
      @type = type
      @properties = options.reverse_merge(
        field: parameter,
        default: false,
        scope_name: nil
      )
    end

    ##
    # Applies this filter to +collection+, dispatching to the scope or
    # where handler based on +type+.
    #
    # @param collection [ActiveRecord::Relation] the collection to filter
    # @param value [Object] the active filter param value
    # @return [ActiveRecord::Relation] the filtered collection
    def apply!(collection, value)
      if type == :scope
        Filters::ScopeHandler.new.call(collection, value, properties)
      else
        Filters::ColumnHandler.new.call(collection, type, value, properties)
      end
    end

    ##
    # @return [Boolean] whether this filter applies automatically when no filter params were sent at all
    def default
      properties[:default]
    end

    private

    ##
    # @param parameter [Symbol] the public filter param name, used in the error message
    # @param type [Symbol] the filter type to validate
    # @return [nil]
    # @raise [ArgumentError] if +type+ isn't one of {Toller::VALID_TYPES}
    def validate_type!(parameter, type)
      return if Toller::VALID_TYPES.include?(type)

      raise ArgumentError, "Toller: unknown type `#{type.inspect}` for filter `#{parameter}` " \
                           "(expected one of #{Toller::VALID_TYPES.join(', ')})"
    end
  end
end

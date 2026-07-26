# frozen_string_literal: true

module Toller
  ##
  # Sort
  class Sort
    # @return [Symbol] the public sort param name
    attr_reader :parameter

    # @return [Hash] the sort's resolved options (:field, :default, :scope_name, etc.)
    attr_reader :properties

    # @return [Symbol] the sort type, e.g. :string, :integer, :scope
    attr_reader :type

    ##
    # @param parameter [Symbol] the public sort param name
    # @param type [Symbol] the sort type, e.g. :string, :integer, :scope
    # @param options [Hash] sort options; merged over defaults for :field, :default, and :scope_name
    # @option options [Symbol] :field the column/attribute to sort on; defaults to +parameter+
    # @option options [Boolean] :default whether this sort applies automatically when no sort params were sent
    # @option options [Symbol] :scope_name for type: :scope, the model scope to call; defaults to +parameter+
    # @return [Toller::Sort] a new instance of Sort
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
    # Applies this sort to +collection+, dispatching to the scope or
    # order handler based on +type+.
    #
    # @param collection [ActiveRecord::Relation] the collection to sort
    # @param direction [Symbol] the sort direction, :asc or :desc
    # @return [ActiveRecord::Relation] the sorted collection
    def apply!(collection, direction = :asc)
      if type == :scope
        Sorts::ScopeHandler.new.call(collection, direction, properties)
      else
        Sorts::ColumnHandler.new.call(collection, type, direction, properties)
      end
    end

    ##
    # @return [Boolean] whether this sort applies automatically when no sort params were sent at all
    def default
      properties[:default]
    end

    private

    ##
    # @param parameter [Symbol] the public sort param name, used in the error message
    # @param type [Symbol] the sort type to validate
    # @return [nil]
    # @raise [ArgumentError] if +type+ isn't one of {Toller::VALID_TYPES}
    def validate_type!(parameter, type)
      return if Toller::VALID_TYPES.include?(type)

      raise ArgumentError, "Toller: unknown type `#{type.inspect}` for sort `#{parameter}` " \
                           "(expected one of #{Toller::VALID_TYPES.join(', ')})"
    end
  end
end

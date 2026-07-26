# frozen_string_literal: true

require "toller/filter"
require "toller/filters/column_handler"
require "toller/filters/mutators/boolean"
require "toller/filters/mutators/common/range"
require "toller/filters/mutators/date"
require "toller/filters/mutators/datetime"
require "toller/filters/mutators/integer"
require "toller/filters/mutators/time"
require "toller/filters/scope_handler"
require "toller/retriever"
require "toller/sort"
require "toller/sorts/column_handler"
require "toller/sorts/scope_handler"

##
# Toller
#
# Query param based filtering and sorting
module Toller
  extend ActiveSupport::Concern

  ##
  # Coerces a raw string value into a boolean, using the same rule Toller's
  # own `type: :boolean` filters use internally. Handy inside a model scope
  # backing a `type: :scope` filter, which receives the raw param value
  # unmutated.
  #
  # @param value [String] the raw value
  # @return [Boolean] true if +value+ is one of "1", "t", "true", "y", "yes"; false otherwise
  def self.truthy(value)
    Filters::Mutators::Boolean.call(value)
  end

  ##
  # Applies every active filter/sort for the current request to +collection+.
  #
  # @param collection [ActiveRecord::Relation] the collection to filter/sort
  # @return [ActiveRecord::Relation] the filtered and sorted collection
  def retrieve(collection)
    Retriever.filter(collection, filter_params, sort_params, retrievals)
  end

  included do
    # none
  end

  class_methods do
    ##
    # Declares a filter on the including controller.
    #
    # @param parameter [Symbol] the public filter param name
    # @param type [Symbol] the filter type, e.g. :string, :integer, :scope
    # @param options [Hash] filter options, e.g. :field, :scope_name, :default
    # @return [Array<Toller::Filter,Toller::Sort>] the class's updated `_filters` list
    def filter_on(parameter, type:, **options)
      _filters << Filter.new(parameter, type, options)
    end

    ##
    # Declares a sort on the including controller.
    #
    # @param parameter [Symbol] the public sort param name
    # @param type [Symbol] the sort type, e.g. :string, :integer, :scope
    # @param options [Hash] sort options, e.g. :field, :scope_name, :default
    # @return [Array<Toller::Filter,Toller::Sort>] the class's updated `_filters` list
    def sort_on(parameter, type:, **options)
      _filters << Sort.new(parameter, type, options)
    end

    ##
    # @return [Array<Toller::Filter,Toller::Sort>] the filters/sorts declared directly on this class
    #                                              via `filter_on`/`sort_on`
    def _filters
      @_filters ||= []
    end
  end

  ##
  # Filter params
  #
  # @return [Hash] the current request's filter params, keyed by filter parameter name
  def filter_params
    params.fetch(filter_param_key.to_sym, {}).transform_keys { |key| key.to_s.strip.downcase }
  end

  ##
  # Sort param split
  #
  # @return [Array<String>] the current request's sort params, e.g. ['-published_at', 'title']
  def sort_params
    params.fetch(sort_param_key.to_sym, "").split(",").map { |param| param.strip.downcase }.reject(&:empty?)
  end

  ##
  # Override in an including controller to change the query param Toller
  # reads filters from.
  #
  # @return [Symbol] the query param key holding filter params
  def filter_param_key
    :filters
  end

  ##
  # Override in an including controller to change the query param Toller
  # reads sorts from.
  #
  # @return [Symbol] the query param key holding sort params
  def sort_param_key
    :sort
  end

  private

  ##
  # Retrievals
  #
  # @return [Array<Toller::Filter,Toller::Sort>] every Filter and Sort registered via `filter_on`/`sort_on` across the
  #                                              including class's ancestor chain
  def retrievals
    self.class.ancestors.flat_map { |klass| klass.try(:_filters) }.compact
  end
end

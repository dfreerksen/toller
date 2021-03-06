# frozen_string_literal: true

require 'toller/filter'
require 'toller/filters/mutators/boolean'
require 'toller/filters/mutators/date'
require 'toller/filters/mutators/datetime'
require 'toller/filters/mutators/integer'
require 'toller/filters/mutators/time'
require 'toller/filters/scope_handler'
require 'toller/filters/where_handler'
require 'toller/retriever'
require 'toller/sort'
require 'toller/sorts/order_handler'
require 'toller/sorts/scope_handler'

##
# Toller
#
# Query param based filtering and sorting
#
module Toller
  extend ActiveSupport::Concern

  def retrieve(collection)
    Retriever.filter(collection, filter_params, sort_params, retrievals)
  end

  included do
    # none
  end

  class_methods do
    def filter_on(parameter, type:, **options)
      _filters << Filter.new(parameter, type, options)
    end

    def sort_on(parameter, type:, **options)
      _filters << Sort.new(parameter, type, options)
    end

    def _filters
      @_filters ||= []
    end
  end

  def filter_params
    params.fetch(filter_param_key.to_sym, {})
  end

  def sort_params
    params.fetch(sort_param_key.to_sym, '').split(',')
  end

  def filter_param_key
    :filters
  end

  def sort_param_key
    :sort
  end

  private

  def retrievals
    self.class.ancestors.flat_map { |klass| klass.try(:_filters) }.compact
  end
end

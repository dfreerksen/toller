# frozen_string_literal: true

require 'toller/filter'
require 'toller/filtrator'
require 'toller/sort'

##
# Toller
#
# Query param based filtering and sorting
#
module Toller
  extend ActiveSupport::Concern

  def filtrate(collection)
    Filtrator.filter(collection, filter_params, sort_params, retrievals)
  end

  included do
    # none
  end

  class_methods do
    def filter_on(parameter, type:, **options)
      filters << Filter.new(parameter, type, options)
    end

    def sort_on(parameter, type:, **options)
      filters << Sort.new(parameter, type, options)
    end

    def filters
      @filters ||= []
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
    self.class.ancestors.flat_map { |klass| klass.try(:filters) }.compact
  end
end

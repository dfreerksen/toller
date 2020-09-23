# frozen_string_literal: true

module Toller
  ##
  # Retriever
  #
  class Retriever
    attr_reader :collection, :filter_params, :retrievals, :sort_params

    def self.filter(collection, filter_params, sort_params, retrievals)
      new(collection, filter_params, sort_params, retrievals).filter
    end

    def initialize(collection, filter_params, sort_params, retrievals)
      @collection = collection
      @filter_params = filter_params
      @sort_params = sort_params
      @retrievals = retrievals
    end

    def filter
      active_retrievals.reduce(collection) do |items, retrieval|
        param_value = if retrieval.is_a?(Filter)
                        filter_params.fetch(retrieval.parameter, nil)
                      else
                        sort_params.include?("-#{retrieval.parameter}") ? :desc : :asc
                      end

        retrieval.apply!(items, param_value)
      end
    end

    private

    def active_retrievals
      retrievals.select do |retrieval|
        retrieval.is_a?(Filter) ? filtering_activated?(retrieval) : sorting_activated?(retrieval)
      end
    end

    def filtering_activated?(retrieval)
      return true if filter_params.blank? && retrieval.default

      filter_params.fetch(retrieval.parameter, nil).present?
    end

    def sorting_activated?(retrieval)
      return true if sort_params.blank? && retrieval.default

      string_parameter = retrieval.parameter.to_s

      sort_params.include?(string_parameter) || sort_params.include?("-#{string_parameter}")
    end
  end
end

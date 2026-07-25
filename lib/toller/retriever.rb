# frozen_string_literal: true

module Toller
  ##
  # Retriever
  class Retriever
    # @return [ActiveRecord::Relation] the collection being filtered/sorted
    attr_reader :collection

    # @return [Hash] the request's filter params, keyed by filter parameter name
    attr_reader :filter_params

    # @return [Array<Toller::Filter,Toller::Sort>] every Filter and Sort registered on the
    #   including class's ancestor chain
    attr_reader :retrievals

    # @return [Array<String>] the request's sort params, e.g. ['-published_at', 'title']
    attr_reader :sort_params

    ##
    # Builds a Retriever and applies all active filters/sorts to +collection+.
    #
    # @param collection [ActiveRecord::Relation] the collection to filter/sort
    # @param filter_params [Hash] the request's filter params
    # @param sort_params [Array<String>] the request's sort params
    # @param retrievals [Array<Toller::Filter,Toller::Sort>] every registered Filter and Sort
    # @return [ActiveRecord::Relation] the filtered and sorted collection
    def self.filter(collection, filter_params, sort_params, retrievals)
      new(collection, filter_params, sort_params, retrievals).filter
    end

    ##
    # @param collection [ActiveRecord::Relation] the collection to filter/sort
    # @param filter_params [Hash] the request's filter params
    # @param sort_params [Array<String>] the request's sort params
    # @param retrievals [Array<Toller::Filter,Toller::Sort>] every registered Filter and Sort
    # @return [Toller::Retriever] a new instance of Retriever
    def initialize(collection, filter_params, sort_params, retrievals)
      @collection = collection
      @filter_params = filter_params
      @sort_params = sort_params
      @retrievals = retrievals
    end

    ##
    # Reduces over the active filters/sorts, chaining each one's `apply!`
    # onto the collection returned by the previous one.
    #
    # @return [ActiveRecord::Relation] the filtered and sorted collection
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

    ##
    # @return [Array<Toller::Filter,Toller::Sort>] the subset of +retrievals+ that are active for the current request
    def active_retrievals
      retrievals.select do |retrieval|
        retrieval.is_a?(Filter) ? filtering_activated?(retrieval) : sorting_activated?(retrieval)
      end
    end

    ##
    # @param retrieval [Toller::Filter] the filter to check
    # @return [Boolean] whether +retrieval+ is active for the current request
    def filtering_activated?(retrieval)
      return true if filter_params.blank? && retrieval.default

      filter_params.fetch(retrieval.parameter, nil).present?
    end

    ##
    # @param retrieval [Toller::Sort] the sort to check
    # @return [Boolean] whether +retrieval+ is active for the current request
    def sorting_activated?(retrieval)
      return true if sort_params.blank? && retrieval.default

      string_parameter = retrieval.parameter.to_s

      sort_params.include?(string_parameter) || sort_params.include?("-#{string_parameter}")
    end
  end
end

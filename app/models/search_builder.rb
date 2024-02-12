# frozen_string_literal: true
require './lib/newspaper_works/highlight_search_params'

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightRangeLimit::RangeLimitBuilder
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include NewspaperWorks::HighlightSearchParams

  self.default_processor_chain += [
    :add_advanced_parse_q_to_solr, :add_advanced_search_to_solr, :highlight_search_params
  ]

  ##
  # @example Adding a new step to the processor chain
  # self.default_processor_chain += [:add_custom_data_to_query]
  #
  # def add_custom_data_to_query(solr_parameters)
  #   solr_parameters[:custom] = blacklight_params[:user_value]
  # end
end

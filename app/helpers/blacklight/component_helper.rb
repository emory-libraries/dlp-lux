# frozen_string_literal: true
module Blacklight
  module ComponentHelper
    include Blacklight::ComponentHelperBehavior
    # Overrides stock Blacklight method to allow widgets to move around the page
    # more freely.
    def render_results_collection_tools(options = {})
      render_filtered_partials(blacklight_config.view_config(document_index_view_type).collection_actions, options)
    end
  end
end

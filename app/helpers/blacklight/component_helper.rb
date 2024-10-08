# frozen_string_literal: true
module Blacklight
  module ComponentHelper
    include Blacklight::ComponentHelperBehavior
    # Overrides stock Blacklight method to allow widgets to move around the page
    # more freely.
    def render_results_collection_tools(wrapping_class: nil, component: Blacklight::Document::ActionsComponent)
      actions = filter_partials(blacklight_config.view_config(document_index_view_type).collection_actions, {}).map { |_k, v| v }

      render(component.new(actions:, classes: wrapping_class))
    end
  end
end

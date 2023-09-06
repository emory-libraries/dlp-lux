# frozen_string_literal: true

module Lux
  module Metadata
    class FindThisItemComponent < Blacklight::Component
      attr_reader :document, :document_presenter, :fields, :title
      def initialize(document:)
        @document = document
        @document_presenter = helpers.document_presenter(@document)
        @fields = ::MetadataPresenter.new(
          document: @document_presenter.fields_to_render
        ).terms(:find_this_item)
        @title = this_is_collection ? 'Find This Collection' : 'Find This Item'
      end

      def this_is_collection
        @document["has_model_ssim"]&.first == "Collection"
      end
    end
  end
end

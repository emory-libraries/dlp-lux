# frozen_string_literal: true

module Lux
  module Metadata
    class AboutThisCollectionComponent < Blacklight::Component
      attr_reader :document, :document_presenter, :fields

      def initialize(document:)
        @document = document
        @document_presenter = helpers.document_presenter(@document)
        @fields = ::MetadataPresenter.new(
          document: @document_presenter.fields_to_render
        ).terms(:about_this_collection)
      end
    end
  end
end

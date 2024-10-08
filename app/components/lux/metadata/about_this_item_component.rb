# frozen_string_literal: true

module Lux
  module Metadata
    class AboutThisItemComponent < Blacklight::Component
      attr_reader :document, :document_presenter, :fields

      def initialize(document:)
        @document = document
      end

      def present_resolution_download_restriction
        sanitize(helpers.resolution_download_restriction(@document))
      end

      def before_render
        @document_presenter = helpers.document_presenter(@document)
        @fields = ::AboutThisItemPresenter.new(
          document: @document_presenter.fields_to_render
        ).terms
      end
    end
  end
end

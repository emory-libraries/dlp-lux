# frozen_string_literal: true

module Lux
  module Metadata
    class AccessAndCopyrightComponent < Blacklight::Component
      attr_reader :document, :document_presenter, :fields, :emory_rights_statement,
        :rights_statement, :human_readable_rights_statement

      def initialize(document:)
        @document = document
        @emory_rights_statement = @document["emory_rights_statements_tesim"]&.first
        @rights_statement = @document["rights_statement_tesim"]&.first
        @human_readable_rights_statement = @document["human_readable_rights_statement_ssim"]&.first
      end

      def this_is_work
        @document["has_model_ssim"]&.first == "CurateGenericWork"
      end

      def rights_statment_non_applicable
        @rights_statement == "Not Applicable"
      end

      def before_render
        @document_presenter = helpers.document_presenter(@document)
        @fields = ::MetadataPresenter.new(
          document: @document_presenter.fields_to_render
        ).terms(:access_and_copyright)
      end
    end
  end
end

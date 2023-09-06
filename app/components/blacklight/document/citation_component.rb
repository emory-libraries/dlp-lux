# frozen_string_literal: true
# Blacklight v7.33.1 Override - use our logic instead
require './lib/emory/citation_formatter'

module Blacklight
  module Document
    # Render citations for the document
    class CitationComponent < Blacklight::Component
      DEFAULT_FORMATS = {
        'blacklight.citation.mla': 'modern-language-association',
        'blacklight.citation.apa': 'apa',
        'blacklight.citation.chicago': 'chicago-fullnote-bibliography'
      }.freeze

      with_collection_parameter :document

      # @param [Blacklight::Document] document
      # @param [Hash<String => Symbol>] formats map of citation format names (suspiciously, i18n keys
      #   for them) to document methods that return the formatted citation.
      def initialize(document:, formats: DEFAULT_FORMATS)
        @document = document
        @formats = formats
        @generator = ::Emory::CitationFormatter.new(@document)
      end

      # @return [String]
      def title
        ::Deprecation.silence(::Blacklight::BlacklightHelperBehavior) do
          helpers.document_heading(@document)
        end
      end
    end
  end
end

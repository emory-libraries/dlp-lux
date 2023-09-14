# frozen_string_literal: true
# Blacklight v7.33.1 Override - use our logic instead
require './lib/emory/citation_formatter'

class Lux::Document::CitationComponent < Blacklight::Document::CitationComponent
  DEFAULT_FORMATS = {
    'blacklight.citation.mla': 'modern-language-association',
    'blacklight.citation.apa': 'apa',
    'blacklight.citation.chicago': 'chicago-fullnote-bibliography'
  }.freeze

  # @param [Blacklight::Document] document
  # @param [Hash<String => Symbol>] formats map of citation format names (suspiciously, i18n keys
  #   for them) to document methods that return the formatted citation.
  def initialize(document:, formats: DEFAULT_FORMATS)
    @document = document
    @formats = formats
    @generator = ::Emory::CitationFormatter.new(@document)
  end
end

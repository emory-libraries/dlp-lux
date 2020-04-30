# frozen_string_literal: true
require './lib/emory/citation_formatter'

module CitationHelper
  def mla_citation_txt(document)
    generator = Emory::CitationFormatter.new(document)
    generator.citation_for('modern-language-association')
  end

  def apa_citation_txt(document)
    generator = Emory::CitationFormatter.new(document)
    generator.citation_for('apa')
  end

  def chicago_citation_txt(document)
    generator = Emory::CitationFormatter.new(document)
    generator.citation_for('chicago-fullnote-bibliography')
  end
end

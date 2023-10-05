# frozen_string_literal: true
# Blacklight::Document::CitationComponent v7.33.1 Override - use our logic instead
require 'rails_helper'

RSpec.describe Lux::Document::CitationComponent, type: :component do
  subject(:render) { render_inline(instance) }

  let(:instance) { described_class.new(document: document) }
  let(:document) { PARENT_CURATE_GENERIC_WORK }
  let(:citation_keys) { described_class::DEFAULT_FORMATS.keys }

  it 'creates a new instance of Emory::CitationFormatter' do
    expect(Emory::CitationFormatter).to receive(:new).with(document)
    instance
  end

  it 'has the expected elements' do
    expect(render.css('h3.heading.-h3').map(&:text)).to match_array(citation_keys.map { |ck| I18n.t(ck) })
    expect(render.text).to include(
      'Creator, Sample Parent. Emocad. 1919. Oxford College Library (Oxford, Ga.). https://digital.library.emory.edu/purl/030prr4xkj-cor.'
    )
    expect(render.text).to include(
      'Creator, S. P. (1919). Emocad. Oxford College Library (Oxford, Ga.). https://digital.library.emory.edu/purl/030prr4xkj-cor.'
    )
    expect(render.text).to include(
      'Creator, Sample Parent. “Emocad.” Emory University Yearbooks. Oxford, Georgia, 1919. Oxford College Library (Oxford, Ga.). https://digital.library.emory.edu/purl/030prr4xkj-cor.'
    )
  end
end

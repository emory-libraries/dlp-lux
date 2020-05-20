# frozen_string_literal: true
require 'rails_helper'
require './lib/emory/citation_formatter'

RSpec.describe Emory::CitationFormatter do
  before do
    delete_all_documents_from_solr
    solr = Blacklight.default_index.connection
    solr.add(document)
    solr.commit
  end

  let(:document) { PARENT_CURATE_GENERIC_WORK }
  let(:cit_gen) { described_class.new(document) }
  let(:chicago) { 'chicago-fullnote-bibliography' }
  let(:apa) { 'apa' }
  let(:mla) { 'modern-language-association' }

  it 'creates a citation' do
    expect(cit_gen.citation_for(apa)).not_to be_empty
    expect(cit_gen.citation_for(chicago)).not_to be_empty
    expect(cit_gen.citation_for(mla)).not_to be_empty
  end

  it 'creates three unique default citations' do
    expect(cit_gen.default_citations.values.uniq.size).to eq(3)
  end

  it 'formats each default_citation correctly' do
    expect(cit_gen.default_citations[:"chicago-fullnote-bibliography"]).to(
      eq("Sample Parent Creator, Emocad., 1919/192X, Emory University Yearbooks, Oxford College Library (Oxford, Ga.). https://digital.library.emory.edu/purl/030prr4xkj-cor.")
    )
    expect(cit_gen.default_citations[:apa]).to(
      eq("Creator, S. P. (1919/192X)[Emocad.]. Emory University Yearbooks, Oxford College Library (Oxford, Ga.). https://digital.library.emory.edu/purl/030prr4xkj-cor.")
    )
    expect(cit_gen.default_citations[:'modern-language-association']).to(
      eq("Creator, Sample Parent. Emocad.. 1919/192X. Emory University Yearbooks. Oxford College Library (Oxford, Ga.). https://digital.library.emory.edu/purl/030prr4xkj-cor.")
    )
  end

  it 'always includes the url' do
    url = cit_gen.send(:url, document)

    expect(cit_gen.citation_for(apa)).to include(url)
    expect(cit_gen.citation_for(chicago)).to include(url)
    expect(cit_gen.citation_for(mla)).to include(url)
  end

  it "sanitizes the APA author name correctly in default citation if it's properly formatted" do
    expect(cit_gen.default_citations[:apa]).to include('Creator, S. P.')
  end

  it "sanitizes the MLA author name correctly in default citation if it's properly formatted" do
    expect(cit_gen.default_citations[mla.to_sym]).to include('Creator, Sample Parent')
  end
end

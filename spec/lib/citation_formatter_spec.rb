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

  context '#abnormal_chars?' do
    it 'returns true if abnormal character is found' do
      ab_doc = document.dup.merge(creator_tesim: ["/"])
      ab_doc2 = document.dup.merge(creator_tesim: ["1"])
      ab_doc3 = document.dup.merge(creator_tesim: [","])
      cit_gennie = described_class.new(ab_doc)
      cit_gennie2 = described_class.new(ab_doc2)
      cit_gennie3 = described_class.new(ab_doc3)

      expect(cit_gennie.send(:abnormal_chars?)).to be_truthy
      expect(cit_gennie2.send(:abnormal_chars?)).to be_truthy
      expect(cit_gennie3.send(:abnormal_chars?)).to be_truthy
    end

    it 'returns false if abnormal character is not found' do
      ab_doc = document.dup.merge(creator_tesim: ["ç"])
      cit_gennie = described_class.new(ab_doc)

      expect(cit_gen.send(:abnormal_chars?)).to be_falsey
      expect(cit_gennie.send(:abnormal_chars?)).to be_falsey
    end
  end

  context '#key_value_chunk_1' do
    it "has the right keys" do
      expect(cit_gen.send(:key_value_chunk_1).keys).to(
        eq([:id, :abstract, :archive_location, :author, :"call-number", :edition, :institution])
      )
    end

    it 'has the right values' do
      keys_values_arr = [
        [:id, :item],
        [:abstract, nil],
        [:archive_location, nil],
        [:author, "Sample Parent Creator"],
        [:"call-number", nil],
        [:edition, nil],
        [:institution, "Emory University"]
      ]
      cit_gen_chunk = cit_gen.send(:key_value_chunk_1)

      keys_values_arr.each do |k, v|
        expect(cit_gen_chunk[k]).to eq(v)
      end
    end
  end

  context '#key_value_chunk_2' do
    it "has the right keys" do
      expect(cit_gen.send(:key_value_chunk_2).keys).to(
        eq([:archive, :publisher, :title, :"collection-title", :type, :url])
      )
    end

    it 'has the right values' do
      keys_values_arr = [
        [:archive, "Oxford College Library (Oxford, Ga.)"],
        [:publisher, nil],
        [:title, "Emocad."],
        [:"collection-title", "Emory University Yearbooks"],
        [:type, "text"],
        [:url, "https://digital.library.emory.edu/purl/030prr4xkj-cor"]
      ]
      cit_gen_chunk = cit_gen.send(:key_value_chunk_2)

      keys_values_arr.each do |k, v|
        expect(cit_gen_chunk[k]).to eq(v)
      end
    end
  end

  context '#key_value_chunk_3' do
    it "has the right keys" do
      expect(cit_gen.send(:key_value_chunk_3).keys).to(
        eq([:dimensions, :event, :genre, :ISBN, :ISSN, :keyword, :"publisher-place"])
      )
    end

    it 'has the right values' do
      keys_values_arr = [
        [:dimensions, nil],
        [:event, nil],
        [:genre, nil],
        [:ISBN, nil],
        [:ISSN, nil],
        [:keyword, nil],
        [:"publisher-place", "Oxford, Georgia"]
      ]
      cit_gen_chunk = cit_gen.send(:key_value_chunk_3)

      keys_values_arr.each do |k, v|
        expect(cit_gen_chunk[k]).to eq(v)
      end
    end
  end
end

# frozen_string_literal: true
require 'rails_helper'
require './lib/emory/citation_string_processor'

RSpec.describe CitationStringProcessor, type: :helper do
  describe '#append_string_with_comma' do
    it 'appends a comma if field present' do
      expect(helper.append_string_with_comma(["blah"])).to eq("blah, ")
    end

    it 'returns nil if field nil' do
      expect(helper.append_string_with_comma([""])).to be_nil
    end
  end

  describe '#append_string_with_period' do
    it 'appends a period if field present' do
      expect(helper.append_string_with_period(["blah"])).to eq("blah. ")
    end

    it 'returns nil if field nil' do
      expect(helper.append_string_with_period([""])).to be_nil
    end
  end

  let!(:obj) { CURATE_GENERIC_WORK }

  describe '#apa_edition' do
    it 'prepends a comma and space if edition_tesim present' do
      expect(helper.apa_edition(obj)).to eq(', 3rd ed.')
    end

    it 'returns nil if obj nil' do
      expect(helper.apa_edition(nil)).to be_nil
    end
  end

  describe '#sanitized_citation' do
    let(:citation) do
      "Central Press Photos Ltd. (London, England). Body of Malcolm X in a coffin, with mourners paying their respects. March 3, 1986. Robert Langmuir African American Photograph Collection. Stuart A. Rose Manuscript, Archives, and Rare Book Library"
    end

    it 'prepends a period, space, and url if url not present with no ending period' do
      expect(helper.sanitized_citation(citation, obj)).to eq(citation + ". https://digital.library.emory.edu/purl/123.")
    end

    it 'prepends a space and url if url not present with ending period' do
      expect(helper.sanitized_citation(citation.dup.concat("."), obj)).to eq(citation + ". https://digital.library.emory.edu/purl/123.")
    end

    it 'returns citation if url present' do
      expect(helper.sanitized_citation(citation.dup.concat(". https://digital.library.emory.edu/purl/123."), obj)).to(
        eq(citation + ". https://digital.library.emory.edu/purl/123.")
      )
    end
  end

  describe '#author_name_no_period' do
    it "eliminates period if one exists at end of creator_tesim" do
      expect(helper.author_name_no_period(obj.dup.merge(creator_tesim: ["John Doe Bradley."]))).to(
        eq(["John Doe Bradley"])
      )
    end

    it "passes through creator_tesims that have no period at the end" do
      expect(helper.author_name_no_period(obj.dup.merge(creator_tesim: ["John Doe Bradley"]))).to(
        eq(["John Doe Bradley"])
      )
    end
  end
end

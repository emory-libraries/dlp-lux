# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PublicationDetailsPresenter, run_in_ci: true do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:publication_terms) do
    { publisher_tesim: ['New York Labor News Company'],
      final_published_versions_tesim: ['https://final_version.com'],
      publisher_version_tesim: ['https://publisher_version.com'],
      place_of_production_tesim: ['Carrboro, NC'],
      volume_tesim: ['1'],
      edition_tesim: ['3rd ed.'],
      issue_tesim: ['224'],
      page_range_start_tesim: ['iii'],
      page_range_end_tesim: ['501'],
      issn_tesim: ['0044-8399'],
      isbn_tesim: ['9780415364256'] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(publication_terms)
      end
    end
  end
end

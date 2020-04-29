# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AdditionalDetailsPresenter do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:additional_terms) do
    { human_readable_conference_dates_tesim: ['June 3-5, 1987'],
      conference_name_tesim: ['Pearl Hacks'],
      sponsor_tesim: ['Company, Inc.'],
      data_producers_tesim: ['Genetics Laboratory'],
      grant_agencies_tesim: ['National Endowment for the Arts'],
      grant_information_tesim: ['Can\'t use anything offensive.'],
      author_notes_tesim: ['This is the best data ever.'],
      data_source_notes_tesim: ['From Kari\'s hard drive.'],
      geographic_unit_tesim: ['State'],
      technical_note_tesim: ['This is a note about technical details'] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(additional_terms)
      end
    end
  end
end

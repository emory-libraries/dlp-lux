# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FindThisItemPresenter do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:find_this_item_terms) do
    { id: '123',
      system_of_record_ID_tesim: ['System of record ID seems to be a user entered string'],
      emory_ark_tesim: ['This is a legacy Emory ARK ID'],
      other_identifiers_tesim: ['oclc:(OCoLC)772049332', 'barcode:050000087509'],
      institution_tesim: ['Emory University'],
      holding_repository_tesim: ['Oxford College Library'],
      administrative_unit_tesim: ['Stuart A. Rose Manuscript, Archives, and Rare Book Library'],
      sublocation_tesim: ['That weird cart in the third basement'],
      local_call_number_tesim: ['ML450.B613 v. 3'],
      contact_information_tesim: ['Call Milly'] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(find_this_item_terms)
      end
    end
  end
end

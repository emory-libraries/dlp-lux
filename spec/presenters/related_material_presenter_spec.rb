# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RelatedMaterialPresenter do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:related_terms) do
    { related_material_notes_tesim: ['Other related materials and other things.'],
      related_publications_tesim: ['Sister Outsider'],
      related_datasets_tesim: ['Other datasets that are somehow relevant.'] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(related_terms)
      end
    end
  end
end

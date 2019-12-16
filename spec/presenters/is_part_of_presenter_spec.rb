# frozen_string_literal: true
require 'rails_helper'

RSpec.describe IsPartOfPresenter do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:is_part_of_terms) do
    { member_of_collections_ssim: ['Chester W. Topp collection of Victorian yellowbacks and paperbacks'] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(is_part_of_terms)
      end
    end
  end
end

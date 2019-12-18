# frozen_string_literal: true
require 'rails_helper'

RSpec.describe IsPartOfPresenter, run_in_ci: true do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:contains_terms) do
    { member_of_collections_ssim: ['Chester W. Topp collection of Victorian yellowbacks and paperbacks'] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(contains_terms)
      end
    end
  end
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AboutThisCollectionPresenter do
  let(:pres) { described_class.new(document: COLLECTION) }
  let(:about_terms) do
    { abstract_tesim: ["Collection of yellowbacks and paperbacks collected by Chester W. Topp.  Yellowbacks are cheap novels published in the late nineteenth and early twentieth century in Great Britain."],
      creator_tesim: ["Topp, Chester W., collector."],
      holding_repository_tesim: ["Stuart A. Rose Manuscript, Archives, and Rare Book Library"]}
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(about_terms)
      end
    end
  end
end

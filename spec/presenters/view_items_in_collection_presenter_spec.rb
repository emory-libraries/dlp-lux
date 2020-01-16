# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ViewItemsInCollectionPresenter do
  let(:pres) { described_class.new(document: COLLECTION) }
  let(:view_items) do
    { title_tesim: ["Chester W. Topp collection of Victorian yellowbacks and paperbacks"] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(view_items)
      end
    end
  end
end

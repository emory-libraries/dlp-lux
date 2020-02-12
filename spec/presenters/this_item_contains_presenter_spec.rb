# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ThisItemContainsPresenter do
  let(:contains_children) do
    { "child_works_for_lux_tesim" =>
      ["111, /fake/thumbnail/path/1, First Child",
       "222, /fake/thumbnail/path/2, Second Child",
       "333, /fake/thumbnail/path/3, Third Child"] }
  end
  let(:pres) { described_class.new(document: contains_children) }
  context 'with a solr document' do
    describe '#children' do
      it 'has the correct children' do
        expect(pres.children).to eq(
          [{ id: "111", thumbnail_path: "/fake/thumbnail/path/1", title: "First Child" },
           { id: "222", thumbnail_path: "/fake/thumbnail/path/2", title: "Second Child" },
           { id: "333", thumbnail_path: "/fake/thumbnail/path/3", title: "Third Child" }]
        )
      end
    end
  end
end

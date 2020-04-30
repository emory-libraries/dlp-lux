# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MetadataPresenter do
  let(:pres) { described_class.new(document: COLLECTION) }
  let(:about_terms) do
    { abstract_tesim: ["Collection of yellowbacks and paperbacks collected by Chester W. Topp.  Yellowbacks are cheap novels published in the late nineteenth and early twentieth century in Great Britain."],
      finding_aid_link_ssm: ["https://my-finding-aid.com"],
      creator_tesim: ["Topp, Chester W., collector."],
      contributors_tesim: ["Someone else"],
      primary_language_tesim: ["eng"],
      notes_tesim: ["a brief note"] }
  end
  let(:view_items_terms) do
    {
      title_tesim: ["Chester W. Topp collection of Victorian yellowbacks and paperbacks"]
    }
  end
  let(:is_part_of_terms) do
    { member_of_collections_ssim: ['Chester W. Topp collection of Victorian yellowbacks and paperbacks'],
      member_of_collection_ids_ssim: ['805fbg79d6-cor'] }
  end


  context 'with a solr document' do
    describe '#about_this_collection' do
      it 'has the correct terms' do
        expect(pres.about_this_collection).to eq(about_terms)
      end
    end
    describe '#view_items_in_this_collection' do
      it 'has the correct terms' do
        expect(pres.view_items_in_this_collection).to eq(view_items_terms)
      end
    end
    describe '#is_part_of' do
      it 'has the correct terms' do
        expect(pres.is_part_of).to eq(is_part_of_terms)
      end
    end
  end
end

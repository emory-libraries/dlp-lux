# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MetadataPresenter do
  context "with a CurateGenericWork" do
    let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
    let(:is_part_of_terms) do
      { member_of_collections_ssim: ['Chester W. Topp collection of Victorian yellowbacks and paperbacks'],
        member_of_collection_ids_ssim: ['805fbg79d6-cor'] }
    end
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
    describe '#terms' do
      it 'has the "is part of" terms' do
        expect(pres.terms(:is_part_of)).to eq(is_part_of_terms)
      end
      it 'has the "find this item" terms' do
        expect(pres.terms(:find_this_item)).to eq(find_this_item_terms)
      end
    end
  end

  context "with a Collection" do
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
      { member_of_collections_ssim: ['A pretend Parent collection for the Yellowbacks Collection'],
        member_of_collection_ids_ssim: ['805fbg79d6-cor'] }
    end
    describe '#terms' do
      it 'has the "about this collection" terms' do
        expect(pres.terms(:about_this_collection)).to eq(about_terms)
      end
      it 'has the "view items in this collection" terms' do
        expect(pres.terms(:view_items_in_this_collection)).to eq(view_items_terms)
      end
      it 'has the "is part of" terms' do
        expect(pres.terms(:is_part_of)).to eq(is_part_of_terms)
      end
    end
  end
end

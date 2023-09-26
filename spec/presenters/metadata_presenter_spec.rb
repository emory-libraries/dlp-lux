# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MetadataPresenter do
  context "with a CurateGenericWork" do
    describe 'is part of' do
      include_context('with parsed terms', 'work', :is_part_of)
      let(:expected_terms) do
        { 'member_of_collections_ssim' => ['Chester W. Topp collection of Victorian yellowbacks and paperbacks'],
          'member_of_collection_ids_ssim' => ['805fbg79d6-cor'] }
      end

      include_examples('tests for expected terms')
    end

    describe 'find this item' do
      include_context('with parsed terms', 'work', :find_this_item)
      let(:expected_terms) do
        { 'id' => ['123'],
          'system_of_record_ID_tesim' => ['System of record ID seems to be a user entered string'],
          'emory_ark_tesim' => ['This is a legacy Emory ARK ID'],
          'other_identifiers_tesim' => ['oclc:(OCoLC)772049332', 'barcode:050000087509'],
          'institution_tesim' => ['Emory University'],
          'holding_repository_tesim' => ['Oxford College Library'],
          'administrative_unit_tesim' => ['Stuart A. Rose Manuscript, Archives, and Rare Book Library'],
          'sublocation_tesim' => ['That weird cart in the third basement'],
          'local_call_number_tesim' => ['ML450.B613 v. 3'],
          'contact_information_tesim' => ['Call Milly'] }
      end

      include_examples('tests for expected terms')
    end
  end

  context "with a Collection" do
    describe 'about this collection' do
      include_context('with parsed terms', 'collection', :about_this_collection)
      let(:expected_terms) do
        { 'abstract_tesim' => ["Collection of yellowbacks and paperbacks collected by Chester W. Topp.  Yellowbacks are cheap novels published in the late nineteenth and early twentieth century in Great Britain."],
          'finding_aid_link_ssm' => ["https://my-finding-aid.com"],
          'creator_tesim' => ["Topp, Chester W., collector."],
          'contributors_tesim' => ["Someone else"],
          'primary_language_tesim' => ["eng"],
          'notes_tesim' => ["a brief note"] }
      end

      include_examples('tests for expected terms')
    end

    describe 'view items in this collection' do
      include_context('with parsed terms', 'collection', :view_items_in_this_collection)
      let(:expected_terms) { { 'title_tesim' => ["Chester W. Topp collection of Victorian yellowbacks and paperbacks"] } }

      include_examples('tests for expected terms')
    end

    describe 'is part of' do
      include_context('with parsed terms', 'collection', :is_part_of)
      let(:expected_terms) do
        { 'member_of_collections_ssim' => ['A pretend Parent collection for the Yellowbacks Collection'],
          'member_of_collection_ids_ssim' => ['805fbg79d6-cor'] }
      end

      include_examples('tests for expected terms')
    end
  end
end

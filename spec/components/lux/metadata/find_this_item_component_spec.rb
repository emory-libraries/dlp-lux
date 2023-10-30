# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::FindThisItemComponent, type: :component do
  include_context('setup common component variables')
  let(:doc) { SolrDocument.new(doc_type) }
  let(:fields) do
    ::MetadataPresenter.new(document: doc_presenter.fields_to_render).terms(:find_this_item)
  end
  let(:section_config) { YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'find_this_item.yml'))) }

  context 'for a work' do
    let(:doc_type) { CURATE_GENERIC_WORK }

    it 'has the right card title' do
      with_controller_class(CatalogController) { expect(render.css('.card-header').text).to include('Find This Item') }
    end

    include_examples('tests for expected component labels and values', '.card-body dl dt')
  end

  context 'for a collection' do
    let(:doc_type) { COLLECTION }
    let(:section_config) do
      YAML.safe_load(
        File.open(Rails.root.join('config', 'metadata', 'find_this_item.yml'))
      ).except("system_of_record_ID_tesim", "other_identifiers_tesim", "sublocation_tesim")
    end

    it 'has the right card title' do
      with_controller_class(CatalogController) { expect(render.css('.card-header').text).to include('Find This Collection') }
    end

    include_examples('tests for expected component labels and values', '.card-body dl dt')
  end
end

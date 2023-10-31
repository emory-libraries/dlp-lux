# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::IsPartOfComponent, type: :component do
  include_context('setup common component variables')
  let(:doc) { SolrDocument.new(doc_type) }
  let(:fields) do
    ::MetadataPresenter.new(document: doc_presenter.fields_to_render).terms(:is_part_of)
  end
  let(:section_config) { YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'is_part_of.yml'))) }

  context 'for a work' do
    let(:doc_type) { CURATE_GENERIC_WORK }

    it 'returns the right boolean for collection member test' do
      expect(instance.collection_member_present).to eq(true)
    end

    it 'returns the right boolean for parent work test' do
      expect(instance.parent_work_present).to eq(false)
    end

    it 'has the right google tag values' do
      with_controller_class(CatalogController) do
        # holding_repository_view gtag
        expect(render.css('script').text).to include("gtag('event', \"Oxford College Library\"")
        expect(render.css('script').text).to include("'event_label': 'The Title of my Work'")
      end
    end

    it 'has the right link value' do
      with_controller_class(CatalogController) do
        expect(render).to have_link(
          'Chester W. Topp collection of Victorian yellowbacks and paperbacks',
          href: '805fbg79d6-cor'
        )
      end
    end
  end

  context 'for a collection' do
    let(:doc_type) { COLLECTION }

    it 'returns the right boolean for collection member test' do
      expect(instance.collection_member_present).to eq(true)
    end

    it 'returns the right boolean for parent work test' do
      expect(instance.parent_work_present).to eq(false)
    end

    it 'has the right link value' do
      with_controller_class(CatalogController) do
        expect(render).to have_link(
          'A pretend Parent collection for the Yellowbacks Collection',
          href: '805fbg79d6-cor'
        )
      end
    end

    it 'has the right google tag values' do
      with_controller_class(CatalogController) do
        # holding_repository_view gtag
        expect(render.css('script').text).to include("gtag('event', \"Stuart A. Rose Manuscript, Archives, and Rare Book Library\"")
        expect(render.css('script').text).to include("'event_label': 'Chester W. Topp collection of Victorian yellowbacks and paperbacks'")
      end
    end
  end
end

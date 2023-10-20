# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::FirstColumnComponent, type: :component do
  subject(:render) do
    with_request_url "/catalog/#{doc.id}" do
      render_inline(instance)
    end
  end
  let(:instance) { described_class.new(document: doc) }
  let(:doc) { SolrDocument.new(doc_type) }
  let(:response) { instance_double(Blacklight::Solr::Response) }

  before do
    allow(doc).to receive(:response).and_return(response)
    allow(response).to receive(:[]).with('highlighting').and_return(nil)
  end

  context 'for a work' do
    let(:doc_type) { CURATE_GENERIC_WORK }

    describe '#this_is_collection' do
      it('returns false') { expect(instance.this_is_collection).to be_falsey }
    end

    it 'calls the right components' do
      with_controller_class CatalogController do
        expect(::Lux::Metadata::IsPartOfComponent).to receive(:new).with(document: doc)
        expect(::Lux::Metadata::FindThisItemComponent).to receive(:new).with(document: doc)
        expect(::Lux::Metadata::GenericMetadataComponent).to receive(:new).with(
          document: doc,
          presenter_klass: ::RelatedMaterialPresenter,
          presenter_container_class: 'related-material',
          title: 'Related Material',
          add_class_dt: 'col-md-12',
          add_class_dd: 'col-md-12'
        )

        render
      end
    end
  end

  context 'for a collection' do
    let(:doc_type) { COLLECTION }

    describe '#this_is_collection' do
      it('returns false') { expect(instance.this_is_collection).to be_truthy }
    end

    it 'calls the right components' do
      with_controller_class CatalogController do
        expect(::Lux::Metadata::IsPartOfComponent).to receive(:new).with(document: doc)
        expect(::Lux::Metadata::FindThisItemComponent).to receive(:new).with(document: doc)
        expect(::Lux::Metadata::GenericMetadataComponent).to receive(:new).with(
          document: doc,
          presenter_klass: ::RelatedMaterialPresenter,
          presenter_container_class: 'related-material',
          title: 'Related Material',
          add_class_dt: 'col-md-12',
          add_class_dd: 'col-md-12'
        )

        render
      end
    end
  end
end

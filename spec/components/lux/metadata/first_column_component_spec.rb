# frozen_string_literal: true
require 'rails_helper'
# Note: This component has no rspec associated to it because of the partial call
#   in the html requiring Warden helpers that aren't available in Component specs.

RSpec.describe Lux::Metadata::FirstColumnComponent, type: :component do
  # stub variables without presenter options
  include_context('setup common component variables', false)

  let(:doc) { SolrDocument.new(doc_type) }

  context 'for a work' do
    let(:doc_type) { CURATE_GENERIC_WORK }

    describe '#this_is_collection' do
      it('returns false') { expect(instance.this_is_collection).to be_falsey }
    end

    it 'calls the right components' do
      run_components_call_tests
    end
  end

  context 'for a collection' do
    let(:doc_type) { COLLECTION }

    describe '#this_is_collection' do
      it('returns true') { expect(instance.this_is_collection).to be_truthy }
    end

    it 'calls the right components' do
      run_components_call_tests
    end
  end

  def run_components_call_tests
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

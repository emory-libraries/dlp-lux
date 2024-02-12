# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::SecondColumnComponent, type: :component do
  # stub variables without presenter options
  include_context('setup common component variables', false)

  let(:doc) { SolrDocument.new(doc_type) }

  context 'for a work' do
    let(:doc_type) { CURATE_GENERIC_WORK }

    describe '#this_is_collection' do
      it('returns false') { expect(instance.this_is_collection).to be_falsey }
    end

    describe '#this_is_work' do
      it('returns true') { expect(instance.this_is_work).to be_truthy }
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

    describe '#this_is_work' do
      it('returns false') { expect(instance.this_is_work).to be_falsey }
    end

    it 'calls the right components' do
      run_components_call_tests
    end
  end

  def run_components_call_tests
    with_controller_class CatalogController do
      run_component_call_test(pres_klass: ::SubjectsKeywordsPresenter,
                              pres_container_class: 'subjects-keywords',
                              comp_title: 'Subjects / Keywords')
      run_component_call_test(pres_klass: ::PublicationDetailsPresenter,
                              pres_container_class: 'publication-details',
                              comp_title: 'Publication Details')
      run_component_call_test(pres_klass: ::AdditionalDetailsPresenter,
                              pres_container_class: 'additional-details',
                              comp_title: 'Additional Details')

      render
    end
  end

  def run_component_call_test(pres_klass:, pres_container_class:, comp_title:)
    expect(::Lux::Metadata::GenericMetadataComponent).to receive(:new).with(
      document: doc,
      presenter_klass: pres_klass,
      presenter_container_class: pres_container_class,
      title: comp_title,
      add_class_dt: 'col-md-5',
      add_class_dd: 'col-md-7'
    )
  end
end

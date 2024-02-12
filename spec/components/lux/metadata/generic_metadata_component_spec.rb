# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::GenericMetadataComponent, type: :component do
  include_context('setup common component variables')
  let(:instance) do
    described_class.new(
      document: doc,
      presenter_klass: passed_presenter[:klass],
      presenter_container_class: 'related-material',
      title: 'Related Material',
      add_class_dt: 'col-md-12',
      add_class_dd: 'col-md-12'
    )
  end
  let(:doc) { SolrDocument.new(CURATE_GENERIC_WORK) }
  let(:fields) do
    instance.instance_variable_get(:@presenter_klass).new(document: doc_presenter.fields_to_render).terms
  end
  let(:section_config) { YAML.safe_load(File.open(Rails.root.join('config', 'metadata', passed_presenter[:yaml_file]))) }

  context 'related materials' do
    let(:passed_presenter) { { klass: ::RelatedMaterialPresenter, yaml_file: 'related_material.yml' } }

    include_examples('tests for expected component labels and values')
  end

  context 'subject keywords' do
    let(:passed_presenter) { { klass: ::SubjectsKeywordsPresenter, yaml_file: 'subjects_keywords.yml' } }

    include_examples('tests for expected component labels and values')
  end

  context 'publication details' do
    let(:passed_presenter) { { klass: ::PublicationDetailsPresenter, yaml_file: 'publication_details.yml' } }

    include_examples('tests for expected component labels and values')
  end

  context 'additional details' do
    let(:passed_presenter) { { klass: ::AdditionalDetailsPresenter, yaml_file: 'additional_details.yml' } }

    include_examples('tests for expected component labels and values')
  end
end

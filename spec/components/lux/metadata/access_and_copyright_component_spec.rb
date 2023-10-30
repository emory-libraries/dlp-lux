# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::AccessAndCopyrightComponent, type: :component do
  include_context('setup common component variables')
  let(:doc) { SolrDocument.new(CURATE_GENERIC_WORK) }
  let(:fields) do
    ::MetadataPresenter.new(document: doc_presenter.fields_to_render).terms(:access_and_copyright)
  end
  let(:section_config) { YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'access_and_copyright.yml'))) }
  let(:pulled_linked_element_classes) do
    render.css('.card-body dl dd a').map { |el| el.parent.attributes['class'].value.split(' ').first }
  end
  let(:expected_linked_element_classes) { ['blacklight-rights_statement'] }

  it 'has the expected labels' do
    with_controller_class CatalogController do
      expect(render.css('.card-body dl dt').size).to eq(section_config.size + 2)
      expect(render.css('.card-body dl dt.blacklight-emory_rights_statement').text)
        .to include('Rights Statement:')
      expect(render.css('.card-body dl dt.blacklight-rights_statement').text)
        .to include('Rights Status:')
      section_config.values.each do |value|
        expect(render.css('.card-body dl dt').text).to include(value)
      end
    end
  end

  it 'has the right label/value per row' do
    with_controller_class CatalogController do
      section_config.each do |solr_field, label|
        expect(render.css("dt.blacklight-#{solr_field.parameterize}").text).to include(label)
        expect(render.css('.card-body dl dd.blacklight-emory_rights_statement').text)
          .to include(instance.emory_rights_statement)
        expect(render.css('.card-body dl dd.blacklight-rights_statement').text)
          .to include(instance.human_readable_rights_statement)
        doc[solr_field].each do |value|
          expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include(value)
        end
      end
    end
  end

  include_examples('tests for expected component link values', '.card-body dl dd a')
end

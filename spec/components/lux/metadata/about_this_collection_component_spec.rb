# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::AboutThisCollectionComponent, type: :component do
  subject(:render) do
    with_request_url "/catalog/#{doc.id}" do
      render_inline(instance)
    end
  end
  let(:instance) { described_class.new(document: doc) }
  let(:doc) { SolrDocument.new(COLLECTION) }
  let(:doc_presenter) { Blacklight::ShowPresenter.new(doc, controller.view_context) }
  let(:fields) do
    ::MetadataPresenter.new(document: doc_presenter.fields_to_render).terms(:about_this_collection)
  end
  let(:response) { instance_double(Blacklight::Solr::Response) }
  let(:section_config) { YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'about_this_collection.yml'))) }
  let(:pulled_linked_element_classes) do
    render.css('.row dd a').map { |el| el.parent.attributes['class'].value.split(' ').first }
  end
  let(:expected_linked_element_classes) do
    ["blacklight-creator_tesim", "blacklight-contributors_tesim", "blacklight-primary_language_tesim",
     "blacklight-finding_aid_link_ssm"]
  end

  before do
    allow(instance).to receive(:document_presenter).and_return(doc_presenter)
    allow(instance).to receive(:fields).and_return(fields)
    allow(doc).to receive(:response).and_return(response)
    allow(response).to receive(:[]).with('highlighting').and_return(nil)
  end

  it 'has the expected labels' do
    with_controller_class CatalogController do
      expect(render.css('.row dt').size).to eq(section_config.size)
      section_config.values.each do |value|
        expect(render.css('.row dt').text).to include(value)
      end
    end
  end

  it 'has the right label/value per row' do
    with_controller_class CatalogController do
      section_config.each do |solr_field, label|
        expect(render.css("dt.blacklight-#{solr_field.parameterize}").text).to include(label)
        doc[solr_field].each do |value|
          if solr_field == 'finding_aid_link_ssm'
            expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include('Finding Aid')
          else
            expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include(value)
          end
        end
      end
    end
  end

  it 'has the expected amount of links versus normal text' do
    with_controller_class CatalogController do
      expect(render.css('.row dd a').size).to eq(4)
      expect(pulled_linked_element_classes).to match_array(expected_linked_element_classes)
    end
  end
end

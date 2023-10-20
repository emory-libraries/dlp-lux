# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::FindThisItemComponent, type: :component do
  subject(:render) do
    with_request_url "/catalog/#{doc.id}" do
      render_inline(instance)
    end
  end
  let(:instance) { described_class.new(document: doc) }
  let(:doc) { SolrDocument.new(doc_type) }
  let(:doc_presenter) { Blacklight::ShowPresenter.new(doc, controller.view_context) }
  let(:fields) do
    ::MetadataPresenter.new(document: doc_presenter.fields_to_render).terms(:find_this_item)
  end
  let(:response) { instance_double(Blacklight::Solr::Response) }
  let(:section_config) { YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'find_this_item.yml'))) }

  before do
    allow(instance).to receive(:document_presenter).and_return(doc_presenter)
    allow(instance).to receive(:fields).and_return(fields)
    allow(doc).to receive(:response).and_return(response)
    allow(response).to receive(:[]).with('highlighting').and_return(nil)
  end

  context 'for a work' do
    let(:doc_type) { CURATE_GENERIC_WORK }

    it 'has the right card title' do
      with_controller_class(CatalogController) { expect(render.css('.card-header').text).to include('Find This Item') }
    end

    it 'has the expected labels' do
      with_controller_class CatalogController do
        expect(render.css('.card-body dl dt').size).to eq(section_config.size)
        section_config.values.each do |value|
          expect(render.css('.card-body dl dt').text).to include(value)
        end
      end
    end

    it 'has the right label/value per row' do
      with_controller_class CatalogController do
        section_config.each do |solr_field, label|
          expect(render.css("dt.blacklight-#{solr_field.parameterize}").text).to include(label)
          if doc[solr_field].is_a?(Array)
            doc[solr_field].each do |value|
              expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include(value)
            end
          else
            expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include(doc[solr_field])
          end
        end
      end
    end
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

    it 'has the expected labels' do
      with_controller_class CatalogController do
        expect(render.css('.card-body dl dt').size).to eq(section_config.size)
        section_config.values.each do |value|
          expect(render.css('.card-body dl dt').text).to include(value)
        end
      end
    end

    it 'has the right label/value per row' do
      with_controller_class CatalogController do
        section_config.each do |solr_field, label|
          expect(render.css("dt.blacklight-#{solr_field.parameterize}").text).to include(label)
          if doc[solr_field].is_a?(Array)
            doc[solr_field].each do |value|
              expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include(value)
            end
          else
            expect(render.css("dd.blacklight-#{solr_field.parameterize}").text).to include(doc[solr_field])
          end
        end
      end
    end
  end
end

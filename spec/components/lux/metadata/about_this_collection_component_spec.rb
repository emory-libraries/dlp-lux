# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::AboutThisCollectionComponent, type: :component do
  include_context('setup common component variables')
  let(:doc) { SolrDocument.new(COLLECTION) }
  let(:fields) do
    ::MetadataPresenter.new(document: doc_presenter.fields_to_render).terms(:about_this_collection)
  end
  let(:section_config) { YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'about_this_collection.yml'))) }
  let(:pulled_linked_element_classes) do
    render.css('.row dd a').map { |el| el.parent.attributes['class'].value.split(' ').first }
  end
  let(:expected_linked_element_classes) do
    ["blacklight-creator_tesim", "blacklight-contributors_tesim", "blacklight-primary_language_tesim",
     "blacklight-finding_aid_link_ssm"]
  end

  include_examples('tests for expected component labels and values')
  include_examples('tests for expected component link values')
end

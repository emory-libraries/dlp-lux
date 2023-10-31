# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::AboutThisItemComponent, type: :component do
  include_context('setup common component variables')
  let(:doc) { SolrDocument.new(CURATE_GENERIC_WORK) }
  let(:fields) do
    ::AboutThisItemPresenter.new(document: doc_presenter.fields_to_render).terms
  end
  let(:section_config) { YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'about_this_item.yml'))) }
  let(:pulled_linked_element_classes) do
    render.css('.row dd a').map { |el| el.parent.attributes['class'].value.split(' ').first }
  end
  let(:expected_linked_element_classes) do
    ['blacklight-content_genres_tesim', 'blacklight-contributors_tesim', 'blacklight-creator_tesim',
     'blacklight-human_readable_content_type_ssim', 'blacklight-primary_language_tesim']
  end

  include_examples('tests for expected component labels and values')
  include_examples('tests for expected component link values')
end
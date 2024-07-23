# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RelatedMaterialPresenter do
  include_context('with parsed terms', 'work')
  let(:expected_terms) do
    { "related_material_notes_tesim" => ['Other related materials and other things.'],
      "related_publications_tesim" => ['Sister Outsider'],
      "related_datasets_tesim" => ['Other datasets that are somehow relevant.'] }
  end

  context 'with a solr document, #terms' do
    include_examples 'tests for expected terms'
  end
end

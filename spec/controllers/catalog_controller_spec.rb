# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CatalogController, type: :controller do
  describe 'facets' do
    let(:facets) do
      controller
        .blacklight_config
        .facet_fields.keys
        .map { |field| field.gsub(/\_s+im$/, '') }
    end

    let(:expected_facets) do
      ['holding_repository',
       'member_of_collections',
       'year_created_isim',
       'human_readable_content_type',
       'content_genres',
       'primary_language',
       'year_for_lux_isim',
       'subject_topics',
       'subject_names',
       'subject_geo',
       'human_readable_rights_statement']
    end

    it 'has exactly expected facets' do
      expect(facets).to contain_exactly(*expected_facets)
    end
  end
  #
  describe 'index fields' do
    let(:index_fields) do
      controller
        .blacklight_config
        .index_fields.keys
        .map { |field| field.gsub(/\_s+im$/, '') }
    end

    let(:expected_index_fields) do
      ['creator_tesim',
       'human_readable_date_created_tesim',
       'human_readable_content_type_tesim']
    end
    it { expect(index_fields).to contain_exactly(*expected_index_fields) }
  end

  describe 'search fields' do
    let(:search_fields) { controller.blacklight_config.search_fields.keys }

    let(:expected_search_fields) do
      ['all_fields',
       'title']
    end

    it { expect(search_fields).to contain_exactly(*expected_search_fields) }
  end
end

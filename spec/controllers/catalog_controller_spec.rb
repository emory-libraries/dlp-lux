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
       'source_collection_title',
       'creator',
       'human_readable_content_type',
       'content_genres',
       'primary_language',
       'year_for_lux_isim',
       'subject_topics',
       'subject_names',
       'subject_geo',
       'human_readable_rights_statement',
       'visibility_group_ssi',
       'contributors',
       'keywords',
       'has_model',
       'visibility_ssi']
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
       'holding_repository_tesim',
       'human_readable_content_type',
       'human_readable_date_created_tesim',
       'visibility_group_ssi',
       'all_text_tsimv']
    end
    it { expect(index_fields).to contain_exactly(*expected_index_fields) }
  end

  describe 'search fields' do
    let(:search_fields) { controller.blacklight_config.search_fields.keys }

    let(:expected_search_fields) do
      ['all_fields',
       'common_fields',
       'creator',
       'subject',
       'title',
       'all_fields_advanced',
       'subject_topics',
       'subject_names',
       'subject_geo',
       'subject_time_periods',
       'keywords',
       'table_of_contents',
       'abstract',
       'publisher',
       'content_genres',
       'notes',
       'author_notes',
       'grant_information_notes',
       'technical_note',
       'data_source_notes',
       'related_material_notes']
    end

    it { expect(search_fields).to contain_exactly(*expected_search_fields) }
  end

  describe '#purl' do
    before do
      solr = Blacklight.default_index.connection
      solr.add([work_with_public_visibility])
      solr.commit
    end
    let(:public_work_id) { "222-321" }
    let(:public_work_with_purl_id) { "888-321" }
    let(:public_work_with_purl_purl_id) { "888-321-cor" }
    let(:bad_work_id) { "111" }
    let(:work_with_public_visibility) { WORK_WITH_PUBLIC_VISIBILITY }
    let(:work_with_public_visibility_and_emory_purl) { WORK_WITH_PUBLIC_VISIBILITY_AND_EMORY_PURL }

    context 'when id is found' do
      it 'redirects to the catalog page' do
        get :purl, params: { id: public_work_id }
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to("/catalog/#{public_work_id}")
      end
    end

    context 'when purl is found' do
      before do
        solr = Blacklight.default_index.connection
        solr.add([work_with_public_visibility_and_emory_purl])
        solr.commit
      end

      it 'redirects to the catalog page' do
        get :purl, params: { id: public_work_with_purl_purl_id }
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to("/catalog/#{public_work_with_purl_id}")
      end
    end

    context 'when id is not found' do
      it 'redirects to the catalog page' do
        get :purl, params: { id: bad_work_id }
        expect(response).to have_http_status(:not_found)
        expect(response).to render_template('static/not_found')
      end
    end
  end
end

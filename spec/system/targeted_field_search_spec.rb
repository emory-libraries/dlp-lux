# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Search the catalog', type: :system, js: false do
  let(:fields) do
    ['system_of_record_ID',
     'primary_repository_ID',
     'emory_ark',
     'local_call_number',
     'other_identifiers',
     'uniform_title',
     'series_title',
     'parent_title',
     'creator',
     'contributors',
     'keywords',
     'subject_topics',
     'subject_names',
     'subject_geo',
     'subject_time_periods',
     'institution',
     'primary_language',
     'publisher',
     'holding_repository',
     'related_material_notes',
     'place_of_production',
     'administrative_unit',
     'conference_name',
     'sublocation',
     'sponsor',
     'data_producers',
     'grant_agencies',
     'content_genres',
     'grant_information',
     'author_notes',
     'notes',
     'data_source_notes',
     'geographic_unit',
     'technical_note',
     'issn',
     'isbn',
     'abstract',
     'related_publications',
     'related_datasets',
     'table_of_contents']
  end

  before do
    delete_all_documents_from_solr
    solr = Blacklight.default_index.connection
    fields.each_with_index do |f, i|
      solr.add(
        id: i.to_s,
        has_model_ssim: ['CurateGenericWork'],
        title_tesim: "Target in #{f}",
        "#{f}_tesim".to_sym => ['iMCnR6E8'],
        visibility_ssi: ['open']
      )
    end

    # Handle special case of targeted title field
    solr.add(
      id: '9999',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Target in title iMCnR6E8'],
      visibility_ssi: ['open']
    )
    solr.commit
  end

  it 'searches the right fields for Common Fields target' do
    visit root_path
    page.select('Common Fields', from: 'search_field')
    fill_in 'q', with: 'iMCnR6E8'
    click_on 'search'

    result_titles = []
    loop do
      within '#documents' do
        result_titles += page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      end
      break if page.has_link?('Next', href: '#')
      click_link('Next', match: :first)
    end

    expect(result_titles).to contain_exactly(
      'Target in system_of_record_ID',
      'Target in primary_repository_ID',
      'Target in emory_ark',
      'Target in local_call_number',
      'Target in other_identifiers',
      'Target in title iMCnR6E8',
      'Target in uniform_title',
      'Target in series_title',
      'Target in parent_title',
      'Target in creator',
      'Target in contributors',
      'Target in keywords',
      'Target in subject_topics',
      'Target in subject_names',
      'Target in subject_geo',
      'Target in subject_time_periods'
    )
  end

  it 'searches the right fields for Title target' do
    visit root_path
    page.select('Title', from: 'search_field')
    fill_in 'q', with: 'iMCnR6E8'
    click_on 'search'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in title iMCnR6E8',
        'Target in uniform_title',
        'Target in series_title',
        'Target in parent_title'
      )
    end
  end

  it 'searches the right fields for Creator target' do
    visit root_path
    page.select('Creator', from: 'search_field')
    fill_in 'q', with: 'iMCnR6E8'
    click_on 'search'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in creator',
        'Target in contributors'
      )
    end
  end

  it 'searches the right fields for Subject target' do
    visit root_path
    page.select('Subject', from: 'search_field')
    fill_in 'q', with: 'iMCnR6E8'
    click_on 'search'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in keywords',
        'Target in subject_topics',
        'Target in subject_names',
        'Target in subject_geo',
        'Target in subject_time_periods'
      )
    end
  end

  it 'search the right fields for All Fields target' do
    visit root_path
    page.select('All Fields', from: 'search_field')
    fill_in 'q', with: 'iMCnR6E8'
    click_on 'search'

    result_titles = []

    loop do
      within '#documents' do
        result_titles += page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      end
      break if page.has_link?('Next', href: '#')
      click_link('Next', match: :first)
    end

    expect(result_titles).to contain_exactly(
      'Target in system_of_record_ID',
      'Target in primary_repository_ID',
      'Target in emory_ark',
      'Target in local_call_number',
      'Target in other_identifiers',
      'Target in title iMCnR6E8',
      'Target in uniform_title',
      'Target in series_title',
      'Target in parent_title',
      'Target in creator',
      'Target in contributors',
      'Target in keywords',
      'Target in subject_topics',
      'Target in subject_names',
      'Target in subject_geo',
      'Target in subject_time_periods',
      'Target in institution',
      'Target in primary_language',
      'Target in publisher',
      'Target in holding_repository',
      'Target in related_material_notes',
      'Target in place_of_production',
      'Target in administrative_unit',
      'Target in conference_name',
      'Target in sublocation',
      'Target in sponsor',
      'Target in data_producers',
      'Target in grant_agencies',
      'Target in content_genres',
      'Target in grant_information',
      'Target in author_notes',
      'Target in notes',
      'Target in data_source_notes',
      'Target in geographic_unit',
      'Target in technical_note',
      'Target in issn',
      'Target in isbn',
      'Target in abstract',
      'Target in related_publications',
      'Target in related_datasets',
      'Target in table_of_contents'
    )
  end
end

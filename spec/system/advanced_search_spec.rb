# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search the catalog using advanced search', type: :system, js: false do
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
  let(:search_term) { 'iMCnR6E8' }

  before do
    delete_all_documents_from_solr
    solr = Blacklight.default_index.connection
    fields.each_with_index do |f, i|
      solr.add(
        id: i.to_s,
        has_model_ssim: ['CurateGenericWork'],
        title_tesim: "Target in #{f}",
        "#{f}_tesim".to_sym => [search_term],
        visibility_ssi: ['open']
      )
    end

    def solr_add(solr, id:, title:, uniform_title: nil, publisher: nil)
      solr.add(
        id: id,
        has_model_ssim: ['CurateGenericWork'],
        title_tesim: title,
        uniform_title_tesim: uniform_title,
        publisher_tesim: publisher,
        visibility_ssi: ['open']
      )
    end

    # Handle special case of targeted title field
    solr_add(solr, id: '9999', title: ['Target in title iMCnR6E8'])

    # Add objects to be targeted with multi-field search
    solr_add(solr, id: '111', title: 'Targets in uniform_title and publisher', uniform_title: ['2Hvw5Q55'], publisher: ['3Guv4P44'])
    solr_add(solr, id: '222', title: 'Target in uniform_title only', uniform_title: ['2Hvw5Q55'])

    solr.commit

    visit root_path
    click_link("Advanced Search", match: :first)
  end

  it 'searches the right fields for All Fields target' do
    # Search for something
    fill_in 'all_fields_advanced', with: search_term
    click_on 'advanced-search-submit'

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

  include_examples 'searches_the_right_field_for', 'Title', 'title', [
    'Target in title iMCnR6E8',
    'Target in uniform_title',
    'Target in series_title',
    'Target in parent_title'
  ]
  include_examples 'searches_the_right_field_for', 'Creator', 'creator', [
    'Target in creator',
    'Target in contributors'
  ]
  include_examples 'searches_the_right_field_for', 'Subject - Topics', 'subject_topics', [
    'Target in subject_topics'
  ]
  include_examples 'searches_the_right_field_for', 'Subject - Names', 'subject_names', [
    'Target in subject_names'
  ]
  include_examples 'searches_the_right_field_for', 'Subject - Geographic Locations', 'subject_geo', [
    'Target in subject_geo'
  ]
  include_examples 'searches_the_right_field_for', 'Subject - Time Periods', 'subject_time_periods', [
    'Target in subject_time_periods'
  ]
  include_examples 'searches_the_right_field_for', 'Keywords', 'keywords', [
    'Target in keywords'
  ]
  include_examples 'searches_the_right_field_for', 'Table of Contents', 'table_of_contents', [
    'Target in table_of_contents'
  ]
  include_examples 'searches_the_right_field_for', 'Description / Abstract', 'abstract', [
    'Target in abstract'
  ]
  include_examples 'searches_the_right_field_for', 'Publisher', 'publisher', [
    'Target in publisher'
  ]
  include_examples 'searches_the_right_field_for', 'Genre', 'content_genres', [
    'Target in content_genres'
  ]
  include_examples 'searches_the_right_field_for', 'Note', 'notes', [
    'Target in notes'
  ]
  include_examples 'searches_the_right_field_for', 'Author Notes', 'author_notes', [
    'Target in author_notes'
  ]
  include_examples 'searches_the_right_field_for', 'Grant / Funding Information', 'grant_information_notes', [
    'Target in grant_information'
  ]
  include_examples 'searches_the_right_field_for', 'Technical Note', 'technical_note', [
    'Target in technical_note'
  ]
  include_examples 'searches_the_right_field_for', 'Data Source Notes', 'data_source_notes', [
    'Target in data_source_notes'
  ]
  include_examples 'searches_the_right_field_for', 'Related Material', 'related_material_notes', [
    'Target in related_material_notes'
  ]

  it 'searches multiple fields at once' do
    # Search for two fields
    fill_in 'title', with: '2Hvw5Q55'
    fill_in 'publisher', with: '3Guv4P44'
    click_on 'advanced-search-submit'

    within '#documents' do
      expect(resulting_titles).to contain_exactly(
        'Targets in uniform_title and publisher'
      )
    end
  end

  it 'does not display simple search bar' do
    expect(page).to have_no_css('.search-query-form')
  end

  it 'does not display facets' do
    expect(page).to have_no_css('.limit-criteria')
  end

  context 'accessibility for screen readers' do
    context 'any/all dropdown' do
      it 'has a title that can be read by screen reader' do
        expect(page.find('select#op.input-small')['title']).to eq('find items that match')
      end
    end
  end
end

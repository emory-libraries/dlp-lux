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

    # Add objects to be targeted with multi-field search
    solr.add(
      id: '111',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Targets in uniform_title and publisher',
      uniform_title_tesim: ['2Hvw5Q55'],
      publisher_tesim: ['3Guv4P44'],
      visibility_ssi: ['open']
    )

    solr.add(
      id: '222',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in uniform_title only',
      uniform_title_tesim: ['2Hvw5Q55'],
      visibility_ssi: ['open']
    )

    solr.commit
  end

  it 'searches the right fields for All Fields target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'all_fields_advanced', with: 'iMCnR6E8'
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

  it 'searches the right fields for Title target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'title', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

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
    click_on "More options"
    # Search for something
    fill_in 'creator', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in creator',
        'Target in contributors'
      )
    end
  end

  it 'searches the right field for Subject - Topics target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'subject_topics', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in subject_topics'
      )
    end
  end

  it 'searches the right field for Subject - Names target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'subject_names', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in subject_names'
      )
    end
  end

  it 'searches the right field for Subject - Geographic Locations target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'subject_geo', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in subject_geo'
      )
    end
  end

  it 'searches the right field for Subject - Time Periods target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'subject_time_periods', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in subject_time_periods'
      )
    end
  end

  it 'searches the right field for Keywords target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'keywords', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in keywords'
      )
    end
  end

  it 'searches the right field for Table of Contents target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'table_of_contents', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in table_of_contents'
      )
    end
  end

  it 'searches the right field for Description / Abstract target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'abstract', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in abstract'
      )
    end
  end

  it 'searches the right field for Publisher target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'publisher', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in publisher'
      )
    end
  end

  it 'searches the right field for Genre target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'content_genres', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in content_genres'
      )
    end
  end

  it 'searches the right field for Note target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'notes', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in notes'
      )
    end
  end

  it 'searches the right field for Author Notes target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'author_notes', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in author_notes'
      )
    end
  end

  it 'searches the right field for Grant / Funding Information target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'grant_information_notes', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in grant_information'
      )
    end
  end

  it 'searches the right field for Technical Note target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'technical_note', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in technical_note'
      )
    end
  end

  it 'searches the right field for Data Source Notes target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'data_source_notes', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in data_source_notes'
      )
    end
  end

  it 'searches the right field for Related Material target' do
    visit root_path
    click_on "More options"
    # Search for something
    fill_in 'related_material_notes', with: 'iMCnR6E8'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in related_material_notes'
      )
    end
  end

  it 'searches multiple fields at once' do
    visit root_path
    click_link "More options"
    # Search for two fields
    fill_in 'title', with: '2Hvw5Q55'
    fill_in 'publisher', with: '3Guv4P44'
    click_on 'advanced-search-submit'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Targets in uniform_title and publisher'
      )
    end
  end

  it 'does not display simple search bar' do
    visit root_path
    click_on "More options"
    expect(page).to have_no_css('.search-query-form')
  end

  it 'does not display facets' do
    visit root_path
    click_on "More options"
    expect(page).to have_no_css('.limit-criteria')
  end
end

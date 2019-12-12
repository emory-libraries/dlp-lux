# frozen_string_literal: true
require 'rails_helper'

RSpec.feature "View a Work" do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
    visit solr_document_path(id)
  end

  let(:id) { '123' }

  let(:work_attributes) do
    {
      id: id,
      has_model_ssim: ['CurateGenericWork'],
      visibility_ssi: ['open'],
      # For "About this item" section of show page
      title_tesim: ['The Title of my Work'],
      uniform_title_tesim: ['This is a uniform title'],
      series_title_tesim: ['This is a series title'],
      parent_title_tesim: ['This is a parent title'],
      creator_tesim: ['Smith, Somebody'],
      contributors_tesim: ['Contributor, Jack'],
      date_created_tesim: ['1776', 'XXXX', '192?', '1973?'],
      date_issued_tesim: ['1652'],
      data_collection_dates_tesim: ['1985'],
      human_readable_content_type_tesim: ['Text'],
      content_type_tesim: ['http://id.loc.gov/vocabulary/resourceTypes/txt'],
      content_genres_tesim: ['Painting'],
      extent_tesim: ['152 p., [50] leaves of plates'],
      primary_language_tesim: ['English'],
      notes_tesim: ['notes about a thing'],
      abstract_tesim: ['Description or abstract of work'],
      table_of_contents_tesim: ['Table of contents, Here\'s another content'],
      subject_topics_tesim: ['A topic for a subject'],
      subject_names_tesim: ['Qāsimlū, Mujtabá'],
      subject_geo_tesim: ['New Jersey'],
      subject_time_periods_tesim: ['Edo (African)'],
      keywords_tesim: ['key', 'words'],
      system_of_record_ID_tesim: ['System of record ID seems to be a user entered string'],
      emory_ark_tesim: ['This is a legacy Emory ARK ID'],
      other_identifiers_tesim: ['oclc:(OCoLC)772049332', 'barcode:050000087509'],
      institution_tesim: ['Emory University'],
      holding_repository_tesim: ['Oxford College Library'],
      administrative_unit_tesim: ['Stuart A. Rose Manuscript, Archives, and Rare Book Library'],
      sublocation_tesim: ['That weird cart in the third basement'],
      local_call_number_tesim: ['ML450.B613 v. 3'],
      contact_information_tesim: ['Call Milly']
    }
  end

  it 'has the uv html on the page' do
    expect(page.html).to match(/universal-viewer-iframe/)
  end

  it 'has partials' do
    expect(page).to have_css('.is-part-of')
    expect(page).to have_content('This item is part of:')
    expect(page).to have_css('.about-this-item')
    expect(page).to have_content('About This Item')
    expect(page).to have_css('.contains')
    expect(page).to have_content('This item contains:')
    expect(page).to have_css('.subjects-keywords')
    expect(page).to have_content('Subjects/Keywords')
    expect(page).to have_css('.find-this-item')
    expect(page).to have_content('Find This Item')
    expect(page).to have_css('.publication-details')
    expect(page).to have_content('Publication Details')
    expect(page).to have_css('.related-material')
    expect(page).to have_content('Related Material')
    expect(page).to have_css('.misc-details')
    expect(page).to have_content('Misc Details')
    expect(page).to have_css('.access-and-copyright')
    expect(page).to have_content('Access and Copyright')
  end

  it 'has title, creator, date created, and content type on the page' do
    expect(page).to have_content('The Title of my Work')
    expect(page).to have_content('This is a uniform title')
    expect(page).to have_content('This is a series title')
    expect(page).to have_content('This is a parent title')
    expect(page).to have_content('Smith, Somebody')
    expect(page).to have_content('Contributor, Jack')
    expect(page).to have_content('1776')
    expect(page).to have_content('XXXX')
    expect(page).to have_content('192?')
    expect(page).to have_content('1973?')
    expect(page).to have_content('1652')
    expect(page).to have_content('1985')
    expect(page).to have_content('Text')
    expect(page).to have_content('Painting')
    expect(page).to have_content('152 p., [50] leaves of plates')
    expect(page).to have_content('English')
    expect(page).to have_content('notes about a thing')
    expect(page).to have_content('Description or abstract of work')
    expect(page).to have_content('Table of contents, Here\'s another content')
    expect(page).to have_content('A topic for a subject')
    expect(page).to have_content('Qāsimlū, Mujtabá')
    expect(page).to have_content('New Jersey')
    expect(page).to have_content('Edo (African)')
    expect(page).to have_content('key')
    expect(page).to have_content('words')
    expect(page).to have_content('System of record ID seems to be a user entered string')
    expect(page).to have_content('This is a legacy Emory ARK ID')
    expect(page).to have_content('oclc:(OCoLC)772049332')
    expect(page).to have_content('barcode:050000087509')
    expect(page).to have_content('Emory University')
    expect(page).to have_content('Oxford College Library')
    expect(page).to have_content('Stuart A. Rose Manuscript, Archives, and Rare Book Library')
    expect(page).to have_content('That weird cart in the third basement')
    expect(page).to have_content('ML450.B613 v. 3')
    expect(page).to have_content('Call Milly')
  end
end

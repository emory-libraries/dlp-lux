# frozen_string_literal: true
require 'rails_helper'

RSpec.feature "View a Work" do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
  end

  let(:id) { '123' }

  let(:work_attributes) do
    {
      id: id,
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['The Title of my Work'],
      creator_tesim: ['Smith, Somebody'],
      contributors_tesim: ['Contributor, Jack'],
      date_created_tesim: ['1776', 'XXXX', '192?', '1973?'],
      date_issued_tesim: ['1652'],
      uniform_title_tesim: ['This is a uniform title'],
      series_title_tesim: ['This is a series title'],
      parent_title_tesim: ['This is a parent title'],
      abstract_tesim: ['Description or abstract of work'],
      primary_language_tesim: ['English'],
      content_type_tesim: ['http://id.loc.gov/vocabulary/resourceTypes/txt'],
      content_genres_tesim: ['Painting'],
      human_readable_content_type_tesim: ['Text'],
      geographic_unit_tesim: ['State'],
      data_collection_dates_tesim: ['1985'],
      visibility_ssi: ['open'],
      notes_tesim: ['notes about a thing'],
      subject_time_periods_tesim: ['Edo (African)'],
      subject_topics_tesim: ['Cheese'],
      subject_names_tesim: ['Qāsimlū, Mujtabá'],
      subject_geo_tesim: ['New Jersey'],
      keywords_tesim: ['key', 'words']
    }
  end

  it 'has the uv html on the page' do
    visit solr_document_path(id)
    expect(page.html).to match(/universal-viewer-iframe/)
  end

  it 'has title, creator, date created, and content type on the page' do
    visit solr_document_path(id)
    expect(page).to have_content('The Title of my Work')
    expect(page).to have_content('Smith, Somebody')
    expect(page).to have_content('Contributor, Jack')
    expect(page).to have_content('1776')
    expect(page).to have_content('XXXX')
    expect(page).to have_content('192?')
    expect(page).to have_content('1973?')
    expect(page).to have_content('1652')
    expect(page).to have_content('This is a uniform title')
    expect(page).to have_content('This is a series title')
    expect(page).to have_content('This is a parent title')
    expect(page).to have_content('Description or abstract of work')
    expect(page).to have_content('English')
    expect(page).to have_content('Text')
    expect(page).to have_content('Painting')
    expect(page).to have_content('State')
    expect(page).to have_content('1985')
    expect(page).to have_content('notes about a thing')
    expect(page).to have_content('Edo (African)')
    expect(page).to have_content('Qāsimlū, Mujtabá')
    expect(page).to have_content('New Jersey')
    expect(page).to have_content('key')
    expect(page).to have_content('words')
  end
end

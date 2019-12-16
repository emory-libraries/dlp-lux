# frozen_string_literal: true
require 'rails_helper'

RSpec.feature "View Search Results", type: :system, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    ENV['THUMBNAIL_URL'] = 'http://obviously_fake_url.com'
  end

  let(:id) { '123' }

  let(:work_attributes) do
    {
      id: id,
      title_tesim: ['The Title of my Work'],
      creator_tesim: ['Smith, Somebody'],
      date_created_tesim: ['1776', 'XXXX', '192?', '1973?'],
      content_type_tesim: ['http://id.loc.gov/vocabulary/resourceTypes/txt'],
      human_readable_content_type_tesim: ['Text'],
      has_model_ssim: ['CurateGenericWork'],
      visibility_ssi: ['open'],
      thumbnail_path_ss: ['/downloads/825x69p8dh-cor?file=thumbnail']
    }
  end

  it 'has title, creator, date created, and content type on the page' do
    visit "/"
    fill_in 'q', with: 'The Title of my Work'
    click_on 'Search'
    expect(page).to have_content('The Title of my Work')
    expect(page).to have_content('Smith, Somebody')
    expect(page).to have_content('1776')
    expect(page).to have_content('unknown')
    expect(page).to have_content('1920s')
    expect(page).to have_content('1973 approx.')
    expect(page).to have_content('Text')
    expect(page).to have_xpath("//img[@alt='Thumbnail image']")
    expect(page).to have_xpath("//img[@src='http://obviously_fake_url.com/downloads/825x69p8dh-cor?file=thumbnail']")
  end

  xit 'shows available facets on the page' do
    visit "/"
    fill_in 'q', with: 'The Title of my Work'
    click_on 'Search'
    click_on 'Creators'
    expect(page).to have_selector('#facet-creator_tesim')
    click_on 'Content Type'
    expect(page).to have_selector('#facet-human_readable_content_type_tesim')
    click_on 'Date Created'
    expect(page).to have_selector('#facet-date_created_tesim')
  end
end

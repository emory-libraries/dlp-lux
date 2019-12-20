# frozen_string_literal: true
require 'rails_helper'

RSpec.feature "View Facets on Search Results Page", type: :system, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
  end

  let(:id) { '123' }

  let(:work_attributes) do
    CURATE_GENERIC_WORK
  end

  xit 'shows some available facets on the page' do
    visit "/"
    fill_in 'q', with: 'The Title of my Work'
    click_on 'Search'
    click_on 'Library'
    expect(page).to have_selector('#facet-holding_repository_sim')
    click_on 'Format'
    expect(page).to have_selector('#facet-human_readable_content_type_ssim')
    click_on 'Genre'
    expect(page).to have_selector('#facet-content_genres_sim')
    # click_on 'Creators'
    # expect(page).to have_selector('#facet-creator_sim')
    # click_on 'Primary Language'
    # expect(page).to have_selector('#facet-primary_language_sim')
    # click_on 'Subject - Topics'
    # expect(page).to have_selector('#facet-subject_topics_sim')
    # click_on 'Subject - Names'
    # expect(page).to have_selector('#facet-subject_names_sim')
    # click_on 'Subject - Geographic Locations'
    # expect(page).to have_selector('#facet-subject_geo_sim')
    # click_on 'Rights Statement - Controlled'
    # expect(page).to have_selector('#facet-human_readable_rights_statement_ssim')
  end
end

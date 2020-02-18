# frozen_string_literal: true
require 'rails_helper'

RSpec.feature "View Search Results", type: :system, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add([COLLECTION, MULTI_VOLUME_CURATE_GENERIC_WORK, CURATE_GENERIC_WORK_CHILD, CURATE_GENERIC_WORK])
    solr.commit
    ENV['THUMBNAIL_URL'] = 'http://obviously_fake_url.com'
  end

  let(:collection_id) { COLLECTION[:id] }
  let(:parent_work_id) { MULTI_VOLUME_CURATE_GENERIC_WORK[:id] }
  let(:child_work_id) { CURATE_GENERIC_WORK_CHILD[:id] }
  let(:simple_work_id) { CURATE_GENERIC_WORK[:id] }

  context 'when searching for a collection' do
    it 'has title, number of items, and library on the page' do
      visit "/"
      fill_in 'q', with: collection_id
      click_on 'Search'
      expect(page).to have_content('Chester W. Topp collection of Victorian yellowbacks and paperbacks')
      expect(page).to have_content('3 Items')
      expect(page).to have_content('Stuart A. Rose Manuscript, Archives, and Rare Book Library')
    end
  end

  context 'when searching for a hierarchical parent work' do
    it 'has title, number of items, creator, and format on the page' do
      visit "/"
      fill_in 'q', with: parent_work_id
      click_on 'Search'
      expect(page).to have_content('Emocad.')
      expect(page).to have_content('4 Items')
      expect(page).to have_content('Sample Parent Creator')
      expect(page).to have_content('Text')
    end
  end

  context 'when searching for a hierarchical child work' do
    it 'has title, link to parent work, creator, date, and format on the page' do
      visit "/"
      fill_in 'q', with: child_work_id
      click_on 'Search'
      expect(page).to have_content('Emocad. [1924]')
      expect(page).to have_content('Part of: Emocad.')
      expect(page).to have_content('Sample Child Creator')
      expect(page).to have_content('unknown')
      expect(page).to have_content('Text')
    end
  end

  context 'when searching for a simple work' do
    it 'has title, creator, date, format, and access fields on the page' do
      visit "/"
      fill_in 'q', with: simple_work_id
      click_on 'Search'
      expect(page).to have_content('The Title of my Work')
      expect(page).to have_content('Smith, Somebody')
      expect(page).to have_content('1776, unknown, 1920s, and 1973 approx.')
      expect(page).to have_content('Text')
      expect(page).to have_content('Public')
    end
  end
end

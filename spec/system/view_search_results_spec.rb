# frozen_string_literal: true
require 'rails_helper'

RSpec.feature "View Search Results", type: :system, js: false do
  before do
    solr = Blacklight.default_index.connection
    solr.add([COLLECTION, PARENT_CURATE_GENERIC_WORK, CHILD_CURATE_GENERIC_WORK_1, CHILD_CURATE_GENERIC_WORK_2, CHILD_CURATE_GENERIC_WORK_3, CURATE_GENERIC_WORK])
    solr.commit
    ENV['THUMBNAIL_URL'] = 'http://obviously_fake_url.com'
  end
  after { delete_all_documents_from_solr }

  let(:collection_id) { COLLECTION[:id] }
  let(:parent_work_id) { PARENT_CURATE_GENERIC_WORK[:id] }
  let(:child_work_1_id) { CHILD_CURATE_GENERIC_WORK_1[:id] }
  let(:child_work_2_id) { CHILD_CURATE_GENERIC_WORK_2[:id] }
  let(:child_work_3_id) { CHILD_CURATE_GENERIC_WORK_3[:id] }
  let(:simple_work_id) { CURATE_GENERIC_WORK[:id] }

  context 'when searching for a collection' do
    it 'has title, number of items, and library on the page' do
      visit "/"
      fill_in 'q', with: collection_id
      click_on('search')
      expect(page).to have_content('Chester W. Topp collection of Victorian yellowbacks and paperbacks')
      expect(page).to have_content('3 Items')
      expect(page).to have_content('Stuart A. Rose Manuscript, Archives, and Rare Book Library')
      expect(page).to have_css('.document-thumbnail')
      expect(page).to have_link('Thumbnail image')
      find("img[src='http://obviously_fake_url.com/iiif/2150gb5mmj-cor/thumbnail']")
    end
  end

  context 'when searching for a hierarchical parent work' do
    it 'has title, number of items, creator, and format on the page' do
      visit "/"
      fill_in 'q', with: parent_work_id
      click_on('search')
      expect(page).to have_content('Emocad.')
      expect(page).to have_content('4 Items')
      expect(page).to have_content('Sample Parent Creator')
      expect(page).to have_content('Text')
      expect(page).to have_css('.document-thumbnail')
      expect(page).to have_link('Thumbnail image')
      find("img[src='http://obviously_fake_url.com/iiif/433dz08ksb-cor/thumbnail']")
    end
  end

  context 'when searching for a hierarchical child work' do
    it 'has title, link to parent work, creator, date, and format on the page' do
      visit "/"
      fill_in 'q', with: child_work_1_id
      click_on('search')
      expect(page).to have_content('Emocad. [1924]')
      expect(page).to have_content('Part of: Emocad.')
      expect(page).to have_content('Sample Child Creator')
      expect(page).to have_content('unknown')
      expect(page).to have_content('Text')
      expect(page).to have_css('.document-thumbnail')
      expect(page).to have_link('Thumbnail image')
      find("img[src='http://obviously_fake_url.com/iiif/020fttdz2x-cor/thumbnail']")
    end
  end

  context 'when searching for a simple work' do
    it 'has title, creator, date, format, and access fields on the page' do
      visit "/"
      fill_in 'q', with: simple_work_id
      click_on('search')
      expect(page).to have_content('The Title of my Work')
      expect(page).to have_content('Smith, Somebody')
      expect(page).to have_content('1776, unknown, 1920s, and 1973 approx.')
      expect(page).to have_content('Text')
      expect(page).to have_content('Public')
      expect(page).to have_css('.document-thumbnail')
      expect(page).to have_link('Thumbnail image')
      find("img[src='http://obviously_fake_url.com/iiif/825x69p8dh-cor/thumbnail']")
    end
  end

  context 'screen reader readability' do
    it 'wraps document-details row in a dl' do
      visit "/"
      fill_in 'q', with: simple_work_id
      click_on('search')

      expect(page).to have_css('dl.document-heading-second-row')
    end
  end

  context 'when searching for a work indexed for full-text searching' do
    it 'returns only the simple work with the expected elements' do
      visit "/"
      fill_in 'q', with: 'teddy longfellow'
      click_on('search')

      expect(find_all('#documents article header h3 a').size).to eq(1)
      expect(page).to have_content('The Title of my Work')
      expect(page).to have_content('Full-text matches:')
      expect(page).to have_content(
        '... This is the story of Teddy Longfellow, who lived to a hundred and three! ...'
      )
    end
  end
end

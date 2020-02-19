# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "View a multi part Work", type: :system, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add([COLLECTION, PARENT_CURATE_GENERIC_WORK, CHILD_CURATE_GENERIC_WORK_1, CHILD_CURATE_GENERIC_WORK_2, CURATE_GENERIC_WORK])
    solr.commit
    ENV['THUMBNAIL_URL'] = 'http://obviously_fake_url.com'
    visit solr_document_path(parent_work_id)
  end

  let(:collection_id) { COLLECTION[:id] }
  let(:parent_work_id) { PARENT_CURATE_GENERIC_WORK[:id] }
  let(:child_work_1_id) { CHILD_CURATE_GENERIC_WORK_1[:id] }
  let(:child_work_2_id) { CHILD_CURATE_GENERIC_WORK_2[:id] }
  let(:simple_work_id) { CURATE_GENERIC_WORK[:id] }

  it 'has the uv html on the page' do
    expect(page.html).not_to match(/universal-viewer-iframe/)
  end

  it 'has multi-volume work specific partials' do
    expect(page).to have_css('.is-part-of')
    expect(page).to have_content('This item is part of:')
  end

  it 'has multi-volume work specific metadata labels' do
    expect(page).to have_css('.this-item-contains')
  end

  xit 'has multi-volume work specific metadata values' do
    expect(page).to have_content('The Title of my Work')
  end
end

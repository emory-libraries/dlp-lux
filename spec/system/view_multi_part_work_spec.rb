# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "View a multi part Work", type: :system, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add([COLLECTION, PARENT_CURATE_GENERIC_WORK, CHILD_CURATE_GENERIC_WORK_1, CHILD_CURATE_GENERIC_WORK_2, CHILD_CURATE_GENERIC_WORK_3, CURATE_GENERIC_WORK])
    solr.commit
    ENV['THUMBNAIL_URL'] = 'http://obviously_fake_url.com'
    visit solr_document_path(parent_work_id)
  end

  let(:collection_id) { COLLECTION[:id] }
  let(:parent_work_id) { PARENT_CURATE_GENERIC_WORK[:id] }
  let(:child_work_1_id) { CHILD_CURATE_GENERIC_WORK_1[:id] }
  let(:child_work_2_id) { CHILD_CURATE_GENERIC_WORK_2[:id] }
  let(:child_work_3_id) { CHILD_CURATE_GENERIC_WORK_3[:id] }
  let(:simple_work_id) { CURATE_GENERIC_WORK[:id] }

  it 'does not have the uv html on the page' do
    expect(page.html).not_to match(/universal-viewer-iframe/)
  end

  it 'has multi-volume work specific partials' do
    expect(page).to have_css('.is-part-of')
    expect(page).to have_content('This item is part of:')
  end

  it 'has multi-volume work specific metadata labels' do
    expect(page).to have_css('.this-item-contains')
  end

  it 'has the child works\' thumbnails on the page' do
    find("img[src='http://obviously_fake_url.com/downloads/020fttdz2x-cor?file=thumbnail']")
    find("img[src='http://obviously_fake_url.com/downloads/0343r2282s-cor?file=thumbnail']")
    find("img[src='http://obviously_fake_url.com/downloads/211kh1895r-cor?file=thumbnail']")
  end
end

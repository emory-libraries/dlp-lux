# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "View a Collection", type: :system, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
    visit solr_document_path(id)
  end

  let(:id) { '119f4qrfj9-cor' }

  let(:work_attributes) do
    COLLECTION
  end

  it 'has the uv html on the page' do
    expect(page.html).to match(/universal-viewer-iframe/)
  end

  it 'has only Collection-specific partials' do
    expect(page).to have_css('.view-items-in-collection')
    expect(page).to have_css('.about-this-collection')
    expect(page).to have_content('About This Collection')
    expect(page).not_to have_css('.about-this-item')
    expect(page).to have_css('.is-part-of')
    expect(page).to have_content('This item is part of:')
  end

  it 'has Collection specific metadata labels' do
    expect(page).to have_content('View items in this digital collection')
    expect(page).to have_link('View items in this digital collection', href: "#{root_path}?f%5Bmember_of_collections_ssim%5D%5B%5D=#{CGI.escape(work_attributes[:title_tesim]&.first)}&per_page=10")
  end

  it 'has Collection specific metadata values' do
    expect(page).to have_content('Chester W. Topp collection of Victorian yellowbacks and paperbacks')
  end
end

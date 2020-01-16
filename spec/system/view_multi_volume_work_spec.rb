# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "View a multi volume Work", type: :system, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
    visit solr_document_path(id)
  end

  let(:id) { '030prr4xkj-cor' }

  let(:work_attributes) do
    MULTI_VOLUME_CURATE_GENERIC_WORK
  end

  xit 'has the uv html on the page' do
    expect(page.html).to match(/universal-viewer-iframe/)
  end

  xit 'has multi-volume work specific partials' do
    expect(page).to have_css('.is-part-of')
    expect(page).to have_content('This item is part of:')
  end

  xit 'has multi-volume work specific metadata labels' do
    expect(page).to have_content('Uniform Title:')
  end

  xit 'has multi-volume work specific metadata values' do
    expect(page).to have_content('The Title of my Work')
  end
end

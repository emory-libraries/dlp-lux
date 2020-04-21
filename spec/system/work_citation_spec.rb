# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "View a Work Citation", type: :system, js: false do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
    visit solr_document_path(id)
    click_link('citationLink')
  end

  let(:id) { '123' }

  let(:work_attributes) do
    CURATE_GENERIC_WORK
  end

  it 'has a disclaimer' do
    expect(page).to have_content('Provided as a suggestion only. Please verify these automated citations against the guidelines of your preferred style.')
  end

  it 'has the right headers' do
    expect(page).to have_content('APA, 6th edition')
    expect(page).to have_content('Chicago')
    expect(page).to have_content('MLA')
  end

  it 'provides the right link 3 times' do
    expect(page).to have_content('https://digital.library.emory.edu/purl/123', count: 3)
  end

  it 'shows the APA correctly' do
    expect(page).to have_content('Smith, S. The Title of my Work (3rd ed.). New York Labor News Company. https://digital.library.emory.edu/purl/123')
  end

  it 'shows the Chicago Fullnote correctly' do
    expect(page).to have_content('Smith, Somebody. The Title of My Work. 3Rd ed. New York Labor News Company, n.d. https://digital.library.emory.edu/purl/123.')
  end

  it 'shows the MLA correctly' do
    expect(page).to have_content('Smith, Somebody. The Title of My Work. 3Rd ed., New York Labor News Company, https://digital.library.emory.edu/purl/123.')
  end
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "View a Work Citation", type: :system, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
    visit solr_document_path(id)
    first("#citationLink").click
  end

  let(:id) { "030prr4xkj-cor" }
  let(:work_attributes) { PARENT_CURATE_GENERIC_WORK }

  it 'has a disclaimer' do
    expect(page).to have_content('Provided as a suggestion only. Please verify these automated citations against the guidelines of your preferred style.')
  end

  it 'has the right headers' do
    expect(page).to have_content('APA, 6th edition')
    expect(page).to have_content('Chicago')
    expect(page).to have_content('MLA')
  end

  it 'provides the right link 3 times' do
    within '.modal-content' do
      expect(page).to have_content('https://digital.library.emory.edu/purl/030prr4xkj-cor', count: 3)
    end
  end

  it 'shows the APA correctly' do
    expect(page).to have_content('Creator, S. P. (1919). Emocad. Oxford College Library (Oxford, Ga.). https://digital.library.emory.edu/purl/030prr4xkj-cor.')
  end

  it 'shows the Chicago Fullnote correctly' do
    expect(page).to have_content('Creator, Sample Parent. “Emocad.” Emory University Yearbooks. Oxford, Georgia, 1919. Oxford College Library (Oxford, Ga.). https://digital.library.emory.edu/purl/030prr4xkj-cor.')
  end

  it 'shows the MLA correctly' do
    expect(page).to have_content('Creator, Sample Parent. Emocad. 1919. Oxford College Library (Oxford, Ga.). https://digital.library.emory.edu/purl/030prr4xkj-cor.')
  end
end

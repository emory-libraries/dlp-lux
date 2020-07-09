# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'viewing search history', type: :system do
  before do
    solr = Blacklight.default_index.connection
    solr.add([COLLECTION, PARENT_CURATE_GENERIC_WORK])
    solr.commit
  end

  context 'after searching in the catalog' do
    it 'has right subheader' do
      visit "/"
      fill_in 'q', with: "Emocad"
      click_on('search')
      visit '/search_history'

      expect(page).to have_content('Your recent searches (cleared after your browser session)')
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search a prod-like catalog', type: :system, run_in_ci: false, relevancy: true, js: true do

  it 'gets correct search results' do

    # Do we need to make sure any previously opened connections have closed?
    visit 'https://digital-arch.library.emory.edu:443'
    # Search for something
    fill_in 'q', with: 'hats'
    click_on 'search'

    within '#documents' do
      expect(page).to have_content('Streets of steps')
    end
  end
end

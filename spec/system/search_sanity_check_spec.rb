# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search a prod-like catalog', type: :system, run_in_ci: false, relevancy: true, js: true do

let(:url) do
  prod_env = ENV.fetch("PROD_LIKE_ENV")
  case prod_env
  when 'qa'
    'https://lux-qa.curationexperts.com:443'
  when 'test'
    'https://digital-test.library.emory.edu:443'
  when 'arch'
    'https://digital-arch.library.emory.edu:443'
  when 'prod'
    'https://digital.library.emory.edu:443'
  end
end

  it 'gets correct search results' do
    visit url
    # Search for something
    fill_in 'q', with: 'emory'
    click_on 'search'

    within '#documents' do
      expect(page).to have_content('Emory University Yearbooks')
    end
  end
end

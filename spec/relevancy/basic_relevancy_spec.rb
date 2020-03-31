# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search a prod-like catalog', type: :system, run_in_ci: false, relevancy: true, js: true do

  let(:username) { "lux" }
  let(:password) { "lux2020" }
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
      "https://#{username}:#{password}@digital.library.emory.edu:443"
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

  it "finds only a few results for 'barber dog'" do
    visit url
    # Search for something
    fill_in 'q', with: 'barber dog'
    click_on 'search'
    expect(page.find(:xpath, '/html/body/main/div[3]/section[1]/div[1]/div[1]/span/strong[3]').text.to_i).to be_between(1, 5).inclusive
  end

  it "finds many results for 'barber'" do
    visit url
    # Search for something
    fill_in 'q', with: 'barber'
    click_on 'search'
    expect(page.find(:xpath, '/html/body/main/div[3]/section[1]/div[1]/div[1]/span/strong[3]').text.to_i).to be > 50
  end

  it "finds at least 40 results for 'Jesse Jackson'" do
    visit url
    # Search for something
    fill_in 'q', with: 'Jesse Jackson'
    click_on 'search'
    expect(page.find(:xpath, '/html/body/main/div[3]/section[1]/div[1]/div[1]/span/strong[3]').text.to_i).to be >= 40
  end
end

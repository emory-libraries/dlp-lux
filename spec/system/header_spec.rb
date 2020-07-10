# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'header', type: :system do
  before { visit '/' }

  it 'has expected css' do
    expect(page).to have_css '.branding-header'
    expect(page).to have_css '.search-query-form'
    expect(page).to have_css("img[src*='shield']")
  end

  it 'has expected links' do
    expect(page).to have_link 'Advanced Search'
    expect(page).to have_link('Emory Libraries', href: 'https://libraries.emory.edu/')
    link = find(:xpath, "//div[@class='branding-header logo']//a")
    expect(link[:href]).to eq('/')
    expect(page).to have_link('Emory University', href: 'https://emory.edu/')
  end
end

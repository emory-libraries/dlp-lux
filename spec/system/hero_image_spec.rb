# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'hero images', type: :system do
  it 'has expected content' do
    visit "/"
    expect(page).to have_css ".carousel"
    expect(page).to have_css ".carousel-caption"
    expect(page).to have_text "Emory Digital Collections"
    expect(page).to have_link "View Featured Item"
  end

  it 'only displays on the homepage' do
    visit "/advanced"
    expect(page).not_to have_css ".carousel"
  end
end

# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'header', type: :system do
  it 'has expected css' do
    visit "/"
    expect(page).to have_css ".branding-header"
    expect(page).to have_link "Advanced Search"
    expect(page).to have_css ".search-query-form"
    expect(page).to have_link "Emory Libraries"
  end
end

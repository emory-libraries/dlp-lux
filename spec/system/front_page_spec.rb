# frozen_string_literal: true
require 'rails_helper'
require_relative '../../db/concerns/default_explore_collections'
include Warden::Test::Helpers
include DefaultExploreCollections

RSpec.describe 'front page', type: :system do
  before do
    stub_default_explore_collections
    visit '/'
  end

  it 'has featured collections' do
    expect(page).to have_content 'Health Sciences Center Library Artifact Collection'
    expect(page).to have_content 'Robert Langmuir African American Photograph Collection'
    expect(page).to have_content 'Oxford College Collection of Asian Artifacts'
  end

  it 'has a meta description tag' do
    expect(page).to have_css(
      'meta[name="description"][content="The digital front door to the unique cultural heritage and scholarship material from Emory Libraries. Discover, view, and download images, books, and more from our campus repositories."]',
      visible: false
    )
  end

  it 'has Explore Our Collections hyperlink', js: true do
    explore_path = find('a.browse-link', text: "Explore Our Collections")['href']

    expect(explore_path).to include('has_model_ssim', 'Collection', 'visibility_ssi', 'open')
  end
end

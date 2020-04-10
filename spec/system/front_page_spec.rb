# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'front page', type: :system do
  it 'has featured collections' do
    visit "/"
    expect(page).to have_content 'Health Sciences Center Library Artifact Collection'
    expect(page).to have_content 'Robert Langmuir African American Photograph Collection'
    expect(page).to have_content 'Oxford College Collection of Asian Artifacts'
  end
end

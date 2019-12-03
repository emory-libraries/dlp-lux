# frozen_string_literal: true
require 'rails_helper'

RSpec.feature "View Search Results" do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
  end

  let(:id) { '123' }

  let(:work_attributes) do
    {
      id: id,
      title_tesim: ['The Title of my Work'],
      creator_tesim: ['Smith, Somebody'],
      date_created_tesim: ['1776'],
      content_type_tesim: ['http://id.loc.gov/vocabulary/resourceTypes/txt']
    }
  end

  it 'has title, creator, date created, and content type on the page' do
    visit "/"
    fill_in 'q', with: 'The Title of my Work'
    click_on 'Search'
    expect(page).to have_content('The Title of my Work')
    expect(page).to have_content('Smith, Somebody')
    expect(page).to have_content('1776')
    expect(page).to have_content('http://id.loc.gov/vocabulary/resourceTypes/txt')
  end
end

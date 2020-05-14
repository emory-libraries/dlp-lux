# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search the catalog', type: :system, js: false do
  before do
    delete_all_documents_from_solr
    solr = Blacklight.default_index.connection
    solr.add([orange, banana, apple, potato])
    solr.commit
  end

  let(:orange) do
    {
      id: '111',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Orange Carrot'],
      title_ssort: 'Orange Carrot',
      year_for_lux_ssi: 2000,
      creator_ssort: 'Bittersweet Tangerine',
      visibility_ssi: ['open']
    }
  end

  let(:banana) do
    {
      id: '222',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Yellow Banana'],
      title_ssort: 'Yellow Banana',
      year_for_lux_ssi: 2001,
      creator_ssort: 'Buff Saffron',
      visibility_ssi: ['open']
    }
  end

  let(:apple) do
    {
      id: '333',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['red Apple'],
      title_ssort: 'red Apple',
      year_for_lux_ssi: 2002,
      creator_ssort: 'Sour Grapes',
      visibility_ssi: ['open']
    }
  end

  let(:potato) do
    {
      id: '444',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['A Potato'],
      title_ssort: 'Potato',
      visibility_ssi: ['open']
    }
  end

  it 'has correct sorting behavior for Date (Newest)' do
    visit '/?q=&search_field=common_fields&sort=year_for_lux_ssi+desc%2C+title_ssort+asc'
    expect(page).to have_content("Results\n1.\nred Apple\n2.\nYellow Banana\n3.\nOrange Carrot\n4.\nA Potato\nSelect")
  end

  it 'has correct sorting behavior for Date (Oldest)' do
    visit '/?q=&search_field=common_fields&sort=year_for_lux_ssi+asc%2C+title_ssort+asc'
    expect(page).to have_content("Results\n1.\nOrange Carrot\n2.\nYellow Banana\n3.\nred Apple\n4.\nA Potato\nSelect")
  end

  it 'has correct sorting behavior for Creator (A-Z)' do
    visit '/?q=&search_field=common_fields&sort=creator_ssort+asc'
    expect(page).to have_content("Results\n1.\nOrange Carrot\n2.\nYellow Banana\n3.\nred Apple\n4.\nA Potato\nSelect")
  end

  it 'has correct sorting behavior for Creator (Z-A)' do
    visit '/?q=&search_field=common_fields&sort=creator_ssort+desc'
    expect(page).to have_content("Results\n1.\nred Apple\n2.\nYellow Banana\n3.\nOrange Carrot\n4.\nA Potato\nSelect")
  end

  it 'has correct sorting behavior for Title (A-Z)' do
    visit '/?q=&search_field=common_fields&sort=title_ssort+asc%2C+year_for_lux_ssi+desc'
    expect(page).to have_content("Results\n1.\nOrange Carrot\n2.\nA Potato\n3.\nred Apple\n4.\nYellow Banana\nSelect")
  end

  it 'has correct sorting behavior for Title (Z-A)' do
    visit '/?q=&search_field=common_fields&sort=title_ssort+desc%2C+year_for_lux_ssi+desc'
    expect(page).to have_content("Results\n1.\nYellow Banana\n2.\nred Apple\n3.\nA Potato\n4.\nOrange Carrot\nSelect")
  end
end

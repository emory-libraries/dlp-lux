# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search the catalog', type: :system, js: false do
  before do
    delete_all_documents_from_solr
    solr = Blacklight.default_index.connection
    solr.add([orange, banana, apple])
    solr.commit
  end

  let(:orange) do
    {
      id: '111',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Orange Carrot'],
      title_ssort: 'Orange Carrot',
      year_for_lux_isim: [2000],
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
      year_for_lux_isim: [2001],
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
      year_for_lux_isim: [2002],
      creator_ssort: 'Sour Grapes',
      visibility_ssi: ['open']
    }
  end

  it 'has correct sorting behavior for year' do
    visit '/?q=&search_field=common_fields&sort=year_for_lux_isim+desc%2C+title_ssort+asc'
    expect(page).to have_content('1. red Apple')
    expect(page).to have_content('2. Yellow Banana')
    expect(page).to have_content('3. Orange Carrot')
  end

  it 'has correct sorting behavior for creator' do
    visit '/?q=&search_field=common_fields&sort=creator_ssort+asc'
    expect(page).to have_content('1. Orange Carrot')
    expect(page).to have_content('2. Yellow Banana')
    expect(page).to have_content('3. red Apple')
  end

  it 'has correct sorting behavior for title' do
    visit '/?q=&search_field=common_fields&sort=title_ssort+asc%2C+year_for_lux_isim+desc'
    expect(page).to have_content('1. Orange Carrot')
    expect(page).to have_content('2. red Apple')
    expect(page).to have_content('3. Yellow Banana')
  end
end

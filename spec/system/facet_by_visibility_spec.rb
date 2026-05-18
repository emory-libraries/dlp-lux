# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Facet the catalog by visibility', type: :system, js: false do
  include_context('setup common visibility solr documents')

  it 'limits to Public objects using facet' do
    visit root_path
    click_on 'search'

    within('#documents') { test_for_all_but_private }

    click_on 'Access'
    click_link("Public", href: '/?f%5Bvisibility_group_ssi%5D%5B%5D=Public&q=&search_field=common_fields')

    expect(page).to     have_content('Work with Open Access')
    expect(page).to     have_content('Work with Public Low Resolution')
    expect(page).not_to have_content('Work with Emory Low visibility')
    expect(page).not_to have_content('Work with Emory High visibility')
    expect(page).not_to have_content('Work with Rose High View visibility')
    expect(page).not_to have_content('Work with Irish Partner Sites visibility')
    expect(page).not_to have_content('Work with Private visibility')
  end

  it 'limits to "Log In Required" objects using facet' do
    visit root_path
    click_on 'search'

    within('#documents') { test_for_all_but_private }

    click_on 'Access'
    click_on 'Log In Required'

    within '#documents' do
      expect(page).not_to have_content('Work with Open Access')
      expect(page).not_to have_content('Work with Public Low Resolution')
      expect(page).to     have_content('Work with Emory Low visibility')
      expect(page).to     have_content('Work with Emory High visibility')
      expect(page).not_to have_content('Work with Rose High View visibility')
      expect(page).not_to have_content('Work with Irish Partner Sites visibility')
      expect(page).not_to have_content('Work with Private visibility')
    end
  end

  it 'limits to "Reading Room Specific" objects using facet' do
    visit root_path
    click_on 'search'

    within('#documents') { test_for_all_but_private }

    click_on 'Access'
    click_on 'Reading Room Specific'

    within '#documents' do
      expect(page).not_to have_content('Work with Open Access')
      expect(page).not_to have_content('Work with Public Low Resolution')
      expect(page).not_to have_content('Work with Emory Low visibility')
      expect(page).not_to have_content('Work with Emory High visibility')
      expect(page).to     have_content('Work with Rose High View visibility')
      expect(page).not_to have_content('Work with Private visibility')
    end
  end

  def test_for_all_but_private
    expect(page).to     have_content('Work with Open Access')
    expect(page).to     have_content('Work with Public Low Resolution')
    expect(page).to     have_content('Work with Emory High visibility')
    expect(page).to     have_content('Work with Emory Low visibility')
    expect(page).to     have_content('Work with Rose High View visibility')
    expect(page).to     have_content('Work with Irish Partner Sites visibility')
    expect(page).not_to have_content('Work with Private visibility')
  end
end

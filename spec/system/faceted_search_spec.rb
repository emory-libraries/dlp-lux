# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Search the catalog by facets', type: :system, js: false do
  it 'displays correct labels in constraint elements' do
    visit '/?f%5Bholding_repository_sim%5D%5B%5D=Sample+Library'
    expect(page).to have_css('.filter-name', text: /\ALibrary\z/)

    visit '/?f%5Bmember_of_collections_ssim%5D%5B%5D=Sample+Collection'
    expect(page).to have_css('.filter-name', text: /\ACollection\z/)

    visit '/?f%5Bcreator_sim%5D%5B%5D=Sample+Creator'
    expect(page).to have_css('.filter-name', text: /\ACreator\z/)

    visit '/?f%5Bhuman_readable_content_type_ssim%5D%5B%5D=Sample+Format'
    expect(page).to have_css('.filter-name', text: /\AFormat\z/)

    visit '/?f%5Bcontent_genres_sim%5D%5B%5D=Sample+Genre'
    expect(page).to have_css('.filter-name', text: /\AGenre\z/)

    visit '/?f%5Bprimary_language_sim%5D%5B%5D=Sample+Language'
    expect(page).to have_css('.filter-name', text: /\ALanguage\z/)

    visit '/?f%5Bsubject_topics_sim%5D%5B%5D=Sample+Topics'
    expect(page).to have_css('.filter-name', text: /\ASubject - Topics\z/)

    visit '/?f%5Bsubject_names_sim%5D%5B%5D=Sample+Names'
    expect(page).to have_css('.filter-name', text: /\ASubject - Names\z/)

    visit '/?f%5Bsubject_geo_sim%5D%5B%5D=Sample+Geo'
    expect(page).to have_css('.filter-name', text: /\ASubject - Geographic\z/)

    visit '/?f%5Bhuman_readable_rights_statement_ssim%5D%5B%5D=Sample+Rights'
    expect(page).to have_css('.filter-name', text: /\ARights Status\z/)

    visit '/?f%5Bvisibility_group_ssi%5D%5B%5D=Sample+Access'
    expect(page).to have_css('.filter-name', text: /\AAccess\z/)

    visit '/?f%5Bcontributors_sim%5D%5B%5D=Sample+Contributor'
    expect(page).to have_css('.filter-name', text: /\AContributors\z/)

    visit '/?f%5Bkeywords_sim%5D%5B%5D=Sample+Keywords'
    expect(page).to have_css('.filter-name', text: /\AKeywords\z/)
  end
end

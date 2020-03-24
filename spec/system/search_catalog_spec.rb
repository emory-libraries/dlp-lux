# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Search the catalog', type: :system, js: false do
  before do
    delete_all_documents_from_solr
    solr = Blacklight.default_index.connection
    solr.add([orange, banana])
    solr.add([creator,
              contributors,
              abstract,
              table_of_contents,
              keywords,
              subject_topics,
              subject_names,
              subject_geo,
              parent_title,
              uniform_title,
              publisher,
              creator_of_collection])
    solr.commit
    login_as(user)
  end

  let(:orange) do
    {
      id: '111',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Orange Carrot'],
      photographer_tesim: ['Bittersweet Tangerine'],
      description_tesim: ['Long description Long description Long description Long description Long description Long description'],
      visibility_ssi: ['open']
    }
  end

  let(:banana) do
    {
      id: '222',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Yellow Banana'],
      photographer_tesim: ['Buff Saffron'],
      visibility_ssi: ['open']
    }
  end

  let(:creator) do
    {
      id: '333',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in creator',
      creator_tesim: ['3Guv4P44'],
      visibility_ssi: ['open']
    }
  end

  let(:contributors) do
    {
      id: '444',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in contributors',
      contributors_tesim: ['3Guv4P44'],
      visibility_ssi: ['open']
    }
  end

  let(:abstract) do
    {
      id: '555',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in abstract',
      abstract_tesim: ['3Guv4P44'],
      visibility_ssi: ['open']
    }
  end

  let(:table_of_contents) do
    {
      id: '666',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in table of contents',
      table_of_contents_tesim: ['3Guv4P44'],
      visibility_ssi: ['open']
    }
  end

  let(:keywords) do
    {
      id: '777',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in keywords',
      keywords_tesim: ['3Guv4P44'],
      visibility_ssi: ['open']
    }
  end

  let(:subject_topics) do
    {
      id: '888',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in subject topics',
      subject_topics_tesim: ['3Guv4P44'],
      visibility_ssi: ['open']
    }
  end

  let(:subject_names) do
    {
      id: '999',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in subject names',
      subject_names_tesim: ['iMCnR6E8'],
      visibility_ssi: ['open']
    }
  end

  let(:subject_geo) do
    {
      id: '101010',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in subject geo',
      subject_geo_tesim: ['iMCnR6E8'],
      visibility_ssi: ['open']
    }
  end

  let(:parent_title) do
    {
      id: '111111',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in parent title',
      parent_title_tesim: ['iMCnR6E8'],
      visibility_ssi: ['open']
    }
  end

  let(:uniform_title) do
    {
      id: '121212',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in uniform title',
      uniform_title_tesim: ['iMCnR6E8'],
      visibility_ssi: ['open']
    }
  end

  let(:publisher) do
    {
      id: '131313',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: 'Target in publisher',
      publisher_tesim: ['iMCnR6E8'],
      visibility_ssi: ['open']
    }
  end

  let(:creator_of_collection) do
    {
      id: '141414',
      has_model_ssim: ['Collection'],
      title_tesim: 'Target in creator, model is collection',
      creator_tesim: ['iMCnR6E8'],
      visibility_ssi: ['open']
    }
  end

  let(:user) { FactoryBot.create(:user) }

  it 'gets correct search results' do
    visit root_path
    # Search for something
    fill_in 'q', with: 'carrot'
    click_on 'search'

    within '#documents' do
      expect(page).to     have_content('Orange Carrot')
      expect(page).not_to have_content('Yellow Banana')
    end
  end

  it 'finds items by ID' do
    visit root_path
    fill_in 'q', with: '222'
    click_on 'search'

    within '#documents' do
      expect(page).to       have_content('Yellow Banana')
      expect(page).not_to   have_content('Orange Carrot')
    end
  end

  it 'searches the right fields, first set' do
    visit root_path
    fill_in 'q', with: '3Guv4P44'
    click_on 'search'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in creator',
        'Target in contributors',
        'Target in keywords',
        'Target in subject topics'
      )
    end
  end

  it 'searches the right fields, second set' do
    visit root_path
    fill_in 'q', with: 'iMCnR6E8'
    click_on 'search'

    within '#documents' do
      result_titles = page.all(:css, 'h3.document-title-heading/a').to_a.map(&:text)
      expect(result_titles).to contain_exactly(
        'Target in subject names',
        'Target in subject geo',
        'Target in parent title',
        'Target in uniform title',
        'Target in creator, model is collection'
      )
    end
  end

  it 'performs searches from about page' do
    visit "/about"
    fill_in 'q', with: '222'
    click_on 'search'

    within 'span.page-entries' do
      expect(page).to have_content('1 entry found')
    end
  end

  it 'performs searches from copyright-reuse page' do
    visit "/copyright-reuse"
    fill_in 'q', with: '222'
    click_on 'search'

    within 'span.page-entries' do
      expect(page).to have_content('1 entry found')
    end
  end

  it 'performs searches from contact page' do
    visit "/contact"
    fill_in 'q', with: '222'
    click_on 'search'

    within 'span.page-entries' do
      expect(page).to have_content('1 entry found')
    end
  end

  it 'performs searches from bookmarks page' do
    visit "/bookmarks"
    fill_in 'q', with: '222'
    click_on 'search'

    within 'span.page-entries' do
      expect(page).to have_content('1 entry found')
    end
  end

  it 'performs searches from search_history page' do
    visit "/search_history"
    fill_in 'q', with: '222'
    click_on 'search'

    within 'span.page-entries' do
      expect(page).to have_content('1 entry found')
    end
  end
end

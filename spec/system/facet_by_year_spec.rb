# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Facet the catalog by year', type: :system, js: false do
  before do
    delete_all_documents_from_solr
    solr = Blacklight.default_index.connection
    solr.add([llama, newt, eagle])
    solr.commit
  end

  let(:llama) do
    {
      id: '111',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Llama Love'],
      year_for_lux_isim: [1920],
      visibility_ssi: ['open']
    }
  end

  let(:newt) do
    {
      id: '222',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Newt Nutrition'],
      year_for_lux_isim: [1940],
      visibility_ssi: ['open']
    }
  end

  let(:eagle) do
    {
      id: '333',
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Eagle Excellence'],
      visibility_ssi: ['open']
    }
  end

  it 'gets correct search results using year ranges' do
    visit root_path
    click_on 'search'

    within '#documents' do
      expect(page).to have_content('Llama Love')
      expect(page).to have_content('Newt Nutrition')
      expect(page).to have_content('Eagle Excellence')
    end

    fill_in 'range_year_for_lux_isim_begin', with: '1920'
    fill_in 'range_year_for_lux_isim_end', with: '1925'
    click_on 'Apply'

    within '#documents' do
      expect(page).to     have_content('Llama Love')
      expect(page).not_to have_content('Newt Nutrition')
      expect(page).not_to have_content('Eagle Excellence')
    end
  end
end

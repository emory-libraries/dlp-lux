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
    find('.input-group-append input[value="Apply"]').click

    within '#documents' do
      expect(page).to     have_content('Llama Love')
      expect(page).not_to have_content('Newt Nutrition')
      expect(page).not_to have_content('Eagle Excellence')
    end
  end

  it 'gets search results when only date facet is applied', :js do
    visit root_path
    # Apply date facet with default parameters and make sure search results appear
    click_on 'Date'
    find('.input-group-append input[value="Apply"]').click
    expect(page).to have_content('Llama Love')
    expect(page).to have_content('Newt Nutrition')
    expect(page).not_to have_content('Eagle Excellence')
  end

  describe 'when "[Missing]" limiter is clicked' do
    context 'on homepage' do
      it "provides a constraint on the next page" do
        visit root_path
        click_on "Unknown"

        expect(page).to have_content('Remove constraint Date: Unknown')
      end
    end

    context 'on search results page' do
      it "provides a constraint on the next page" do
        visit root_path
        click_on 'search'
        click_on "Unknown"

        expect(page).to have_content('Remove constraint Date: Unknown')
      end
    end
  end
end

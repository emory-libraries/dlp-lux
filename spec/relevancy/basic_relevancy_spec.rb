# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search a prod-like catalog', type: :system, run_in_ci: false, relevancy: true, js: true do

  let(:username) { "lux" }
  let(:password) { "lux2020" }
  let(:url) do
    prod_env = ENV.fetch("PROD_LIKE_ENV")
    case prod_env
    when 'qa'
      'https://lux-qa.curationexperts.com:443'
    when 'test'
      'https://digital-test.library.emory.edu:443'
    when 'arch'
      'https://digital-arch.library.emory.edu:443'
    when 'prod'
      "https://#{username}:#{password}@digital.library.emory.edu:443"
    end
  end
  before do
    visit url
    fill_in 'q', with: search_terms
    click_on 'search'
  end

  context "searches for emory" do
    let(:search_terms) { 'emory' }

    it 'gets correct search results' do
      within '#documents' do
        expect(page).to have_content('Emory University Yearbooks')
      end
    end
  end

  context "searches for 'barber dog'" do
    let(:search_terms) { 'barber dog' }

    it "finds only a few results" do
      expect(results_number).to be_between(1, 5).inclusive
    end
  end

  context "searches for 'barber'" do
    let(:search_terms) { 'barber' }

    it "finds many results" do
      expect(results_number).to be > 50
    end
  end

  context "searches for 'Jesse Jackson'" do
    let(:search_terms) { 'Jesse Jackson' }

    it "finds at least 40 results" do
      expect(results_number).to be >= 40
    end
  end

  context "searches for 'civil rights'" do
    let(:search_terms) { 'civil rights' }

    # This behavior should probably be changed
    it "currently ranks full-text pamphlet above possibly more relevant objects when searching 'civil rights'" do
      within '#documents' do
        expect(page).to have_content('Joseph Poga_ny, the founder of the American Civil Righs Movement')
      end
    end

    it "includes Martin Luther King, Jr. in the first page" do
      within '#documents' do
        expect(page).to have_content('Martin Luther King')
      end
    end
  end

  context "searches for 'Paul Robeson'" do
    let(:search_terms) { 'Paul Robeson' }
    let(:work_title) { 'Alberta Hunter and Paul Robeson on stage' }

    it "ranks images where Paul Robeson is the subject of the photo above other relationships to Robeson" do
      within '#documents' do
        expect(page).to have_content('Alberta Hunter and Paul Robeson on stage')
        expect(rank_in_results_title).to be >= 1
        expect(rank_in_results_title).to be <= 5
      end
    end
  end

  def results_number
    # Finds "of " and a number
    /of\s(\d*)/.match(page.find('.page-entries').text)[1].to_i
  end

  def rank_in_results_title
    page.find(".document-title-heading", text:work_title).find(".document-counter").text.to_i
  end
end

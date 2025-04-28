# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "View search results for works with different levels of visibility", js: true, clean: true, type: :system do
  before do
    delete_all_documents_from_solr
    solr = Blacklight.default_index.connection
    solr.add([
               work_with_emory_high_visibility,
               work_with_public_visibility,
               work_with_public_low_view_visibility,
               work_with_emory_low_visibility,
               work_with_rose_high_visibility,
               work_with_private_visibility
             ])
    solr.commit
    ENV['THUMBNAIL_URL'] = 'http://obviously_fake_url.com'
  end

  let(:emory_high_work_id) { '111-321' }
  let(:public_work_id) { '222-321' }
  let(:public_low_view_work_id) { '333-321' }
  let(:emory_low_work_id) { '444-321' }
  let(:rose_high_work_id) { '555-321' }
  let(:private_work_id) { '666-321' }

  let(:work_with_emory_high_visibility) do
    WORK_WITH_EMORY_HIGH_VISIBILITY
  end

  let(:work_with_public_visibility) do
    WORK_WITH_PUBLIC_VISIBILITY
  end

  let(:work_with_public_low_view_visibility) do
    WORK_WITH_PUBLIC_LOW_VIEW_VISIBILITY
  end

  let(:work_with_emory_low_visibility) do
    WORK_WITH_EMORY_LOW_VISIBILITY
  end

  let(:work_with_rose_high_visibility) do
    WORK_WITH_ROSE_HIGH_VISIBILITY
  end

  let(:work_with_private_visibility) do
    WORK_WITH_PRIVATE_VISIBILITY
  end

  it 'shows search results for all except private works' do
    visit "/"
    click_on('search')
    expect(page).to have_content 'Work with Open Access'
    expect(page).to have_content 'Work with Emory High visibility'
    expect(page).to have_content 'Work with Public Low Resolution'
    expect(page).to have_content 'Work with Emory Low visibility'
    expect(page).to have_content 'Work with Rose High View visibility'

    expect(page).not_to have_content 'Work with Private visibility'
  end

  context 'when searching for a Public work' do
    it 'has the original thumbnail' do
      visit "/"
      fill_in 'q', with: public_work_id
      click_on('search')
      expect(page).to have_css('.document-thumbnail')
      expect(page).to have_link('Thumbnail image')
      find("img[src='http://obviously_fake_url.com/iiif/222-456/thumbnail']")
    end
  end

  context 'when searching for a Public Low View work' do
    it 'has the original thumbnail' do
      visit "/"
      fill_in 'q', with: public_low_view_work_id
      click_on('search')
      expect(page).to have_css('.document-thumbnail')
      expect(page).to have_link('Thumbnail image')
      find("img[src='http://obviously_fake_url.com/iiif/333-456/thumbnail']")
    end
  end

  context "as an unauthenticated user" do
    context 'when searching for an Emory Low Download work' do
      before do
        visit "/"
        fill_in 'q', with: emory_low_work_id
        click_on('search')
      end

      it 'has a generic "Please Login for Access" thumbnail' do
        expect(page).to have_css('.document-thumbnail')
        expect(page).to have_link('Thumbnail image')
        expect(page.find("img.img-fluid")['outerHTML']).to match(/login-required/)
        expect(page).not_to have_css("img[src='http://obviously_fake_url.com/downloads/#{emory_low_work_id}?file=thumbnail']")
      end

      it 'redirects to the login page when user tries to view Emory Low Download work' do
        click_on('Thumbnail image')
        expect(current_path).to eq(new_user_session_path)
      end
    end

    context 'when searching for an Emory High Download work' do
      before do
        visit "/"
        fill_in 'q', with: emory_high_work_id
        click_on('search')
      end

      it 'has a generic "Please Login for Access" thumbnail' do
        expect(page).to have_css('.document-thumbnail')
        expect(page).to have_link('Thumbnail image')
        expect(page.find("img.img-fluid")['outerHTML']).to match(/login-required/)
        expect(page).not_to have_css("img[src='http://obviously_fake_url.com/downloads/#{emory_high_work_id}?file=thumbnail']")
      end

      it 'redirects to the login page when user tries to view Emory High Download work' do
        click_on('Thumbnail image')
        expect(page).to have_link("Log in")
        expect(page).to have_button('Sign in with Shibboleth')
      end
    end
  end

  context "as an authenticated user" do
    let(:user) { FactoryBot.create(:user) }
    before do
      login_as user
    end

    context 'when searching for an Emory Low Download work' do
      it 'has the original thumbnail' do
        visit "/"
        fill_in 'q', with: emory_low_work_id
        click_on('search')
        expect(page).to have_css('.document-thumbnail')
        expect(page).to have_link('Thumbnail image')
        find("img[src='http://obviously_fake_url.com/iiif/444-456/thumbnail']")
      end
    end

    context 'when searching for an Emory High Download work' do
      it 'has the original thumbnail' do
        visit "/"
        fill_in 'q', with: emory_high_work_id
        click_on('search')
        expect(page).to have_css('.document-thumbnail')
        expect(page).to have_link('Thumbnail image')
        find("img[src='http://obviously_fake_url.com/iiif/111-456/thumbnail']")
      end
    end
  end

  context "as a user in the Rose Reading Room" do
    before do
      allow_any_instance_of(Ability).to receive(:user_groups).and_return(['rose_high'])
    end
    it 'has the original thumbnail' do
      visit "/"
      fill_in 'q', with: rose_high_work_id
      click_on('search')
      expect(page).to have_css('.document-thumbnail')
      expect(page).to have_link('Thumbnail image')
      find("img[src='http://obviously_fake_url.com/iiif/555-456/thumbnail']")
    end
  end

  context "as a user outside the Rose Reading Room" do
    it 'has a generic "Reading Room Only" thumbnail' do
      visit "/"
      fill_in 'q', with: rose_high_work_id
      click_on('search')
      expect(page).to have_css('.document-thumbnail')
      expect(page).to have_link('Thumbnail image')
      expect(page.find("img.img-fluid")['outerHTML']).to match(/reading-room-only/)
      expect(page).not_to have_css("img[src='http://obviously_fake_url.com/iiif/555-456/thumbnail']")
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Navigation bar', integration: true, clean: true, type: :system do
  context 'as a logged in user' do
    let(:user) { FactoryBot.create(:user) }
    before do
      login_as user
      visit '/'
    end

    it 'has a bookmarks link' do
      expect(page).to have_link 'Bookmarks'
    end

    it 'has a history link' do
      expect(page).to have_link 'History'
    end

    it 'has a log out link' do
      expect(page).to have_link 'Log Out'
    end

    it 'displays the user\'s name' do
      expect(page).to have_content user.display_name
    end
  end

  context 'as a guest user' do
    before do
      visit '/'
    end

    it 'does not have a bookmarks link' do
      expect(page).not_to have_link 'Bookmarks'
    end

    it 'has a history link' do
      expect(page).to have_link 'History'
    end

    it 'has a login link' do
      expect(page).to have_link 'Login'
    end
  end
end

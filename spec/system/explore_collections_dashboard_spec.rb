# frozen_string_literal: true
require 'rails_helper'
require_relative '../../db/concerns/default_explore_collections'
include DefaultExploreCollections

RSpec.describe 'Explore Collections Dashboard', type: :system do
  before { stub_default_explore_collections }
  let(:explore_collection) { ExploreCollection.first }
  let(:user) { User.create(uid: 'test') }

  context 'when a user is logged in' do
    before { sign_in(user) }

    context 'and is an admin' do
      before { allow_any_instance_of(Ability).to receive(:admin?).and_return(true) }

      it 'loads the explore collections dashboard' do
        visit '/admin/explore_collections'
        expect(status_code).to eq(200)
        expect(page).to have_content('Explore Collections')
      end

      it 'enables user to edit a explore collection' do
        visit '/admin/explore_collections'
        click_link 'Edit', href: "/admin/explore_collections/#{explore_collection.id}/edit"
        fill_in 'explore_collection_title', with: 'new_value'
        find('input[name="commit"]').click
        expect(page).to have_content('Explore collection was successfully updated.')
        explore_collection.reload
        expect(explore_collection.title).to eq('new_value')
      end
    end

    context 'and is a guest' do
      it 'does not load the explore collections dashboard' do
        visit '/admin/explore_collections'
        expect(status_code).to eq(500)
        expect(page.html).not_to have_content('Explore Collections')
      end
    end
  end

  context 'when no user is logged in' do
    it 'does not load the explore collections dashboard' do
      visit '/admin/explore_collections'
      expect(status_code).to eq(500)
      expect(page.html).not_to have_content('Explore Collections')
    end
  end
end

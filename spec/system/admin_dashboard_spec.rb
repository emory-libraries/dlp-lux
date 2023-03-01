# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Dashboard', type: :system do
  let(:user) { User.create(uid: 'test') }
  context 'when a user is logged in' do
    before do
      sign_in(user)
    end

    context 'and is an admin' do
      it 'loads admin dashboard' do
        allow_any_instance_of(Ability).to receive(:admin?).and_return(true)
        visit admin_root_path
        expect(status_code).to eq(200)
        expect(page).to have_content('Admin Dashboard')
      end
    end

    context 'and is a guest' do
      it 'does not load the admin dashboard' do
        visit admin_root_path
        expect(status_code).to eq(500)
        expect(page.html).not_to have_content('Admin Dashboard')
      end
    end
  end

  context 'when no user is logged in' do
    it 'does not load the admin dashboard' do
      visit admin_root_path
      expect(status_code).to eq(500)
      expect(page.html).not_to have_content('Admin Dashboard')
    end
  end
end

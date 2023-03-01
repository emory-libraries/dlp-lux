# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Content Blocks Dashboard', type: :system do
  let!(:content_block) { FactoryBot.create(:content_block) }
  let(:user) { User.create(uid: 'test') }

  context 'when a user is logged in' do
    before { sign_in(user) }

    context 'and is an admin' do
      before { allow_any_instance_of(Ability).to receive(:admin?).and_return(true) }

      it 'loads the content blocks dashboard' do
        visit '/admin/content_blocks'
        expect(status_code).to eq(200)
        expect(page).to have_content('Content Blocks')
      end

      it 'enables user to edit a content block' do
        visit '/admin/content_blocks'
        click_link 'Edit'
        fill_in 'content_block_value', with: 'new_value'
        find('input[name="commit"]').click
        expect(page).to have_content('Content block was successfully updated.')
        content_block.reload
        expect(content_block.value).to eq('new_value')
      end
    end

    context 'and is a guest' do
      it 'does not load the content blocks dashboard' do
        visit '/admin/content_blocks'
        expect(status_code).to eq(500)
        expect(page.html).not_to have_content('Content Blocks')
      end
    end
  end

  context 'when no user is logged in' do
    it 'does not load the content blocks dashboard' do
      visit '/admin/content_blocks'
      expect(status_code).to eq(500)
      expect(page.html).not_to have_content('Content Blocks')
    end
  end
end

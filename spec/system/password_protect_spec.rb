# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Password protect non production instances', type: :system do
  context 'visiting an instance when HTTP_PASSWORD_PROTECT is false' do
    before do
      ENV['HTTP_PASSWORD_PROTECT'] = 'false'
    end
    it 'does not prompt the user for a password' do
      visit('/')
      expect(page).to have_content('Emory')
    end
  end

  context 'visiting an instance when HTTP_PASSWORD_PROTECT is true' do
    before do
      ENV['HTTP_PASSWORD_PROTECT'] = 'true'
    end
    after do
      ENV['HTTP_PASSWORD_PROTECT'] = 'false'
    end
    it 'prompts the user for a password' do
      visit('/')
      expect(page.find(:xpath, '//body').text).to eq "HTTP Basic: Access denied."
    end
  end
end

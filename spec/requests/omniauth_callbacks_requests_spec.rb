# frozen_string_literal: true
require "rails_helper"
include Warden::Test::Helpers
OmniAuth.config.test_mode = true

RSpec.describe OmniauthCallbacksController, :clean, type: :request do
  let(:auth_hash) do
    OmniAuth.config.mock_auth[:shibboleth] = OmniAuth::AuthHash.new(
      provider: 'shibboleth',
      uid: "janeq",
      info: {
        display_name: "Jane Quest",
        uid: 'janeq',
        mail: 'janeq@emory.edu'
      }
    )
  end
  let(:key) { Rails.application.secrets.shared_cookie_key }
  let(:crypt) { ActiveSupport::MessageEncryptor.new(key) }
  let(:user) { User.from_omniauth(auth_hash) }

  before do
    login_as(user)
  end

  it "sets a cookie" do
    get '/users/auth/shibboleth/callback'
    expect(response.cookies).to include "bearer_token"
    expect(crypt.decrypt_and_verify(response.cookies["bearer_token"])).to eq "This is a test token value"
  end
end

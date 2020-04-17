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

  let(:user) { User.from_omniauth(auth_hash) }

  before do
    login_as(user)
  end

  it "sets a cookie" do
    get '/users/auth/shibboleth/callback'
    expect(response.cookies).to include "bearer_token"
    expect(decrypt_string(response.cookies["bearer_token"])).to eq 1.day.from_now.to_s
  end

  def decrypt_string(encrypted_str)
    cipher_salt1 = ENV["IIIF_COOKIE_SALT_1"] || 'another-random-salt-'
    cipher_salt2 = ENV["IIIF_COOKIE_SALT_2"] || 'another-random-salt-'
    cipher = OpenSSL::Cipher.new('AES-128-ECB').decrypt
    cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(cipher_salt1, cipher_salt2, 20_000, cipher.key_len)
    decrypted = [encrypted_str].pack('H*').unpack('C*').pack('c*')
    cipher.update(decrypted) + cipher.final
  end
end

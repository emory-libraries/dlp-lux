# frozen_string_literal: true
require 'openssl'
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def shibboleth
    Rails.logger.debug "OmniauthCallbacksController#shibboleth: request.env['omniauth.auth']: #{request.env['omniauth.auth']}"
    # had to create the `from_omniauth(auth_hash)` class method on our User model
    @user = User.from_omniauth(request.env["omniauth.auth"])
    cookie_pot
    set_flash_message :notice, :success, kind: "Shibboleth"
    sign_in_and_redirect @user
  end

  def cookie_pot
    cookies["bearer_token"] = {
      value: encrypt_string("This is a test token value"),
      expires: 1.day.from_now,
      httponly: true,
      secure: request.ssl?,
      domain: ".emory.edu"
    }
  end

  def encrypt_string(str)
    cipher_salt1 = 'some-random-salt-'
    cipher_salt2 = 'another-random-salt-'
    cipher = OpenSSL::Cipher.new('AES-128-ECB').encrypt
    cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(cipher_salt1, cipher_salt2, 20_000, cipher.key_len)
    encrypted = cipher.update(str) + cipher.final
    encrypted.unpack('H*')[0].upcase
  end
end

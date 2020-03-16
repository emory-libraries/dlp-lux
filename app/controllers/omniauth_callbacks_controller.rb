# frozen_string_literal: true
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
    # cookies.signed["protected"] = "Hello, I can be read, but I can't be tampered with."

    cookies["bearer_token"] = {
      # value: cookie_verifier.generate("This is a test token value"),
      value: dont_spoof_my_cookie,
      expires: 1.hour.from_now,
      httponly: true,
      secure: request.ssl?,
      domain: ".emory.edu"
    }
  end

  def dont_spoof_my_cookie
    cookie_value = "This is a test token value"
    key = Rails.application.secrets.shared_cookie_key
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.encrypt_and_sign(cookie_value)
  end

  # def cookie_verifier
  #   unless @verifier
  #     @verifier = ActiveSupport::MessageVerifier.new(Rails.application.secrets.shared_cookie_key)
  #   end
  #   @verifier
  # end
end

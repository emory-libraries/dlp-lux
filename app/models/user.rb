# frozen_string_literal: true
class User < ApplicationRecord
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User

  class NilShibbolethUserError < RuntimeError
    attr_accessor :auth

    def initialize(message = nil, auth = nil)
      super(message)
      self.auth = auth
    end
  end
  # Include devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # remove :database_authenticatable in production, remove :validatable to integrate with Shibboleth
  devise_modules = [:omniauthable, :rememberable, omniauth_providers: [:shibboleth], authentication_keys: [:uid]]
  devise_modules.prepend(:database_authenticatable) if AuthConfig.use_database_auth?
  devise(*devise_modules)

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    uid
  end

  # When a user authenticates via shibboleth, find their User object or make
  # a new one. Populate it with data we get from shibboleth.
  # @param [OmniAuth::AuthHash] auth
  def self.from_omniauth(auth) # rubocop:disable Metrics/AbcSize
    Rails.logger.debug "auth = #{auth.inspect}"
    raise User::NilShibbolethUserError.new("No uid", auth) if auth.uid.empty? || auth.info.uid.empty?
    user = User.find_or_initialize_by(provider: auth.provider, uid: auth.info.uid)
    user.assign_attributes(display_name: auth.info.display_name)
    # tezprox@emory.edu isn't a real email address
    user.email = auth.info.uid + '@emory.edu' unless auth.info.uid == 'tezprox'
    user.save
    user
  rescue User::NilShibbolethUserError => e
    Rails.logger.error "Nil user detected: Shibboleth didn't pass a uid for #{e.auth.inspect}"
  end

  def self.log_omniauth_error(auth)
    if auth.info.uid.empty?
      Rails.logger.error "Nil user detected: Shibboleth didn't pass a uid for #{auth.inspect}"
    else
      # Log unauthorized logins to error.
      Rails.logger.error "Unauthorized user attemped login: #{auth.inspect}"
    end
  end
end

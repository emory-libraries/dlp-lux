# frozen_string_literal: true

module HttpAuthConcern
  extend ActiveSupport::Concern
  included do
    before_action :http_authenticate
  end
  def http_authenticate
    # Disable http password protection by setting HTTP_PASSWORD_PROTECT = 'false'
    return true unless ENV['HTTP_PASSWORD_PROTECT'] == 'true'

    http_username = ENV['HTTP_USERNAME'] || 'admin'
    http_password = ENV['HTTP_PASSWORD'] || 'changeme'
    authenticate_or_request_with_http_basic do |username, password|
      username == http_username && password == http_password
    end
  end
end

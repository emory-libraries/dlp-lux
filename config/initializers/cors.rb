# frozen_string_literal: true
require 'addressable/uri'

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000', "#{Addressable::URI.parse(ENV['THUMBNAIL_URL']).host}"
    resource '*', headers: :any, methods: methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

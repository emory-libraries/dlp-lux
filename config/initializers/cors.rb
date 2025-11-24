# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "#{Addressable::URI.parse(ENV['THUMBNAIL_URL']).host}"
    resource '*', headers: :any, methods: [:get]
  end
end

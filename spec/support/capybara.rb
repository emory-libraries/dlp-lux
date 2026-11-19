# frozen_string_literal: true

module CapybaraChromeStorageFix
  def clear_storage
    return unless browser.respond_to?(:execute_cdp)

    uri = URI.parse(current_url)
    return unless uri.scheme&.start_with?('http')

    origin = "#{uri.scheme}://#{uri.host}:#{uri.port}"
    browser.execute_cdp('Storage.clearDataForOrigin', origin:, storageTypes: 'all')
  rescue StandardError
    nil
  end
end

# Setup chrome headless driver
Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome_headless do |app|
  Capybara::Selenium::Driver.prepend(CapybaraChromeStorageFix)
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 120

  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:, http_client: client)
end

Capybara.javascript_driver = :chrome_headless

# Setup rspec
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :chrome_headless
  end
end

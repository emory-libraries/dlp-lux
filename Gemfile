# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '3.1.2'

gem 'administrate', '~> 0.17.0'
# Use ActiveModel has_secure_password
# Needed for support of OpenSSH keys
gem 'bcrypt_pbkdf'
# Blacklight 7, because Blacklight 6 did not successfully deploy to production
gem 'blacklight', "7.33.1"
gem 'blacklight-access_controls', git: 'https://github.com/projectblacklight/blacklight-access_controls', branch: 'rails7_ruby3_blacklight8_upgrade'
gem 'blacklight_advanced_search'
gem 'blacklight-marc', '>= 7.0.0.rc1'
gem 'blacklight_range_limit'
gem 'bootstrap', '~> 4.0'
gem 'bootstrap-select-rails', '>= 1.13'
gem 'citeproc-ruby'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
gem 'csl-styles'
gem 'devise'
gem 'dotenv-rails'
# Needed for support of OpenSSH keys
gem 'ed25519'
gem 'honeybadger', '~> 4.0'
gem 'importmap-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'mysql2', '~> 0.5'
gem 'omniauth', '< 2'
# Use shibboleth for user authentication
gem 'omniauth-shibboleth', '~> 1.3'
# Use Puma as the app server
gem 'puma'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0', '>= 7.0.7.2'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
gem 'rsolr', '>= 1.0'
# Use SCSS for stylesheets
gem "sassc-rails", "~> 2.1"
gem 'simple_form'
gem "sprockets-rails"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use Whenever for temp file cleanup chron jobs
gem 'whenever', require: false

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'cap-ec2-emory', github: 'emory-libraries/cap-ec2'
  # Use Capistrano for deployment
  gem "capistrano", "~> 3.11", require: false
  gem 'capistrano-bundler', '~> 1.3'
  gem 'capistrano-ext'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rails-collection'
  gem 'capistrano-sidekiq'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "xray-rails", git: "https://github.com/brentd/xray-rails.git", branch: "bugs/ruby-3.0.0"
end

group :development, :test do
  # bixby = rubocop rules for Hyrax apps
  gem 'bixby'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara'
  gem 'coveralls_reborn', require: false
  gem 'factory_bot_rails', '~> 4.11.1'
  gem 'ffaker'
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
  gem 'rails-controller-testing'
  gem 'rspec-its'
  gem 'rspec-rails', '~> 5.0'
  gem 'selenium-webdriver'
  gem 'solr_wrapper', '>= 0.3'
  gem 'webdrivers', '5.3.0'
end

group :test do
  gem 'rspec_junit_formatter'
end

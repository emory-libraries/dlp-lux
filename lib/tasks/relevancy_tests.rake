# frozen_string_literal: true

namespace :lux do
  desc "Searches catalog in a prod-like environment"
  task test_catalog_search: :environment do
    `bundle exec rspec spec --tag relevancy:true`
    puts "You should have seen the test search by now"
  end
end

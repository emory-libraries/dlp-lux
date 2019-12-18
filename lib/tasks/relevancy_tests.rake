# frozen_string_literal: true

namespace :lux do
  desc "Searches catalog in a prod-like environment"
  task relevancy_tests: :environment do
    `bundle exec rspec spec --tag relevancy:true`
    puts "You should have seen the test search by now"
  end
end

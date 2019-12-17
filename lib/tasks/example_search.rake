# frozen_string_literal: true

namespace :lux do
  desc "Searches catalog in a prod-like environment"
  task test_catalog_search: :environment do
    temp_solr_url = ENV.fetch("RELEVANCY_TEST_SOLR_URL")
    # Something having to do with Blacklight.default_index ? using the temp_solr_url?

    puts "You should have seen the test search by now"
  end
end

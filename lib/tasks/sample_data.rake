# frozen_string_literal: true

namespace :lux do
  desc "Load sample data"
  task load_sample_data: :environment do
    if Rails.env.production?
      puts "This task should not be run in production"
    else
      solr_snapshots_location = Rails.root.join('spec', 'fixtures', 'solr_snapshots')
      solr_snapshot_name = "20191203163502341"
      `curl "#{Blacklight.connection_config[:url]}/replication?command=restore&location=#{solr_snapshots_location}&name=#{solr_snapshot_name}"`
      puts "Loaded sample data"
    end
  end
end

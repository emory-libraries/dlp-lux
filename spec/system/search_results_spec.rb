# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

# It would be cool if we could populate a test solr index and run tests against it.
# However, this is not working in CI.
RSpec.describe 'front page', type: :system, js: true do
  let(:solr_snapshots_location) { "#{fixture_path}/solr_snapshots/" }
  let(:solr_snapshot_name) { "20191203163502341" }

  before do
    `curl "#{Blacklight.connection_config[:url]}/replication?command=restore&location=#{solr_snapshots_location}&name=#{solr_snasphot_name}"`
  end

  xit 'can load snapshot index' do
    visit "/?search_field=all_fields&q="
    expect(page).to have_content '1 - 10 of 54,797'
  end
end

# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'front page', type: :system, js: true do
  let(:solr_snaphots_location) { "#{fixture_path}/solr_snapshots/" }
  let(:solr_snaphot_name) { "20191203163502341" }

  before do
    `curl "#{Blacklight.connection_config[:url]}/replication?command=restore&location=#{solr_snaphots_location}&name=#{solr_snaphot_name}"`
  end

  it 'can load snapshot index' do
    visit "/?search_field=all_fields&q="
    expect(page).to have_content '1 - 10 of 54,797'
  end
end

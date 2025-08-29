# frozen_string_literal: true
require "rails_helper"

RSpec.describe "404 Error Custom Page", type: :request do
  it "loads the page when 404 error detected" do
    get "/1q"

    response_tests
  end

  it "contains the expected text" do
    get "/1q"

    ['Page Not Found', 'You may have reached this page due to an incorrect address.', "Use your browser's back button or return",
     'to continue. For more assistance,'].each { |str| expect(response.body).to include str }
    ['Accessing Emory Digital Collections', 'mailto:rose.library@emory.edu', 'our wiki site',
     'https://wiki.service.emory.edu/display/DLPP/Emory+Digital+Collections+User+Guide'].each do |str|
      expect(response.body).not_to include str
    end
  end

  it "loads the page for unlogged in users looking for bookmarks" do
    get "/bookmarks"
    expect(response.status).to eq 404
  end

  context 'BlacklightRangeLimit::InvalidRange' do
    it 'rescues the error and renders 404' do
      get "/?f[content_genres_sim][]=seals+(artifacts)&f[creator_sim][]=Unknown&f[holding_repository_sim][]=Pitts+Theology+Library" \
        "&page=5&per_page=10&range[year_for_lux_isim][begin]=1428&range[year_for_lux_isim][end]=F5Wa2"

      response_tests
    end
  end

  def response_tests
    expect(response.status).to eq 404
    expect(response.body).not_to be_empty
    expect(response.content_length).to be > 0
    expect(response.content_type).to eq "text/html; charset=utf-8"
    expect(response).to render_template(:not_found)
  end
end

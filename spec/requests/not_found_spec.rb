# frozen_string_literal: true
require "rails_helper"

RSpec.describe "404 Error Custom Page", type: :request do
  it "loads the page when 404 error detected" do
    get "/1q"

    expect(response.status).to eq 404
    expect(response.body).not_to be_empty
    expect(response.content_length).to be > 0
    expect(response.content_type).to eq "text/html"
    expect(response).to render_template(:not_found)
  end

  it "contains the requested headers" do
    get "/1q"

    expect(response.body).to include 'Page Not Available'
    expect(response.body).to include 'Accessing Emory Digital Collections'
    expect(response.body).to include 'mailto:rose.library@emory.edu'
    expect(response.body).to include 'our wiki site'
    expect(response.body).to include 'https://wiki.service.emory.edu/display/DLPP/Emory+Digital+Collections+User+Guide'
  end

  it "loads the page for unlogged in users looking for bookmarks" do
    get "/bookmarks"
    expect(response.status).to eq 404
  end
end

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

    expect(response.body).to include 'Page Not Found'
    expect(response.body).not_to include 'Accessing Emory Digital Collections'
    expect(response.body).not_to include 'mailto:rose.library@emory.edu'
    expect(response.body).not_to include 'our wiki site'
    expect(response.body).not_to include 'https://wiki.service.emory.edu/display/DLPP/Emory+Digital+Collections+User+Guide'
  end

  it "contains the requested links" do
    get "/1q"

    expect(response.body).not_to include 'mailto:rose.library@emory.edu'
    expect(response.body).not_to include 'our wiki site'
    expect(response.body).not_to include 'https://wiki.service.emory.edu/display/DLPP/Emory+Digital+Collections+User+Guide'
  end

  it "loads the page for unlogged in users looking for bookmarks" do
    get "/bookmarks"
    expect(response.status).to eq 404
  end

  it 'contains the right verbiage' do
    get "/1q"

    expect(response.body).to include 'You may have reached this page due to an incorrect address.'
    expect(response.body).to include "Use your browser's back button or return"
    expect(response.body).to include 'to continue. For more assistance,'
  end
end

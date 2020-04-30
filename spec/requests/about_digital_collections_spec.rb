
# frozen_string_literal: true
require "rails_helper"

RSpec.describe "About Digital Collections", type: :request do
  before do
    get "/about"
  end

  it "loads the page without error" do
    expect(response.status).to eq 200
    expect(response.body).not_to be_empty
    expect(response.content_length).to be > 0
    expect(response.content_type).to eq "text/html"
  end

  it 'contains the correct page title'do
    expect(response.body).to include '<title>About Emory Digital Collections - Emory Digital Collections</title>'
  end

  it "contains the requested headers" do
    expect(response.body).to include 'About Emory Digital Collections'
    expect(response.body).to include 'Digital Library Program'
    expect(response.body).to include 'Collections &amp; Content'
    expect(response.body).to include 'Technology'
    expect(response.body).to include 'Questions, Help, and Feedback'
    expect(response.body).to include 'Explore'
  end
end

# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Contact page", type: :request do
  it "loads the page without error" do
    get "/contact"

    expect(response.status).to eq 200
    expect(response.body).not_to be_empty
    expect(response.content_length).to be > 0
    expect(response.content_type).to eq "text/html"
  end

  it "contains the requested headers" do
    get "/contact"

    expect(response.body).to include 'Contact Us'
  end
end

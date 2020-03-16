
# frozen_string_literal: true
require "rails_helper"

RSpec.describe "About Digital Collections", type: :request do
  it "loads the page without error" do
    get "/about"

    expect(response.status).to eq 200
    expect(response.body).not_to be_empty
    expect(response.content_length).to be > 0
    expect(response.content_type).to eq "text/html"
  end

  it "contains the requested headers" do
    get "/about"

    expect(response.body).to include 'About Emory Digital Collections'
    expect(response.body).to include 'How to use Digital Collections'
    expect(response.body).to include 'Technical Information'
    expect(response.body).to include 'Copyright and Reuse'
    expect(response.body).to include 'Contact'
    expect(response.body).to include 'Donate'
  end
end

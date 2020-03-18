# frozen_string_literal: true
require "rails_helper"
require 'capybara'

RSpec.describe "Copyright and Reuse page", type: :request do
  it "loads the page without error" do
    get "/copyright-reuse"

    expect(response.status).to eq 200
    expect(response.body).not_to be_empty
    expect(response.content_length).to be > 0
    expect(response.content_type).to eq "text/html"
  end
end

RSpec.feature "Copyright and Reuse page" do
  context "when Copyright and Reuse loads" do
    it "contains the requested headers" do
      visit "/copyright-reuse"

      page.find('h2', text: 'Copyright and Reuse')
      page.find('p', text: 'Placeholder for copy')
    end
  end
end

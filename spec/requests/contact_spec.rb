# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Contact page", type: :request do
  before do
    get '/contact'
  end

  it "loads the page without error" do
    expect(response.status).to eq 200
    expect(response.body).not_to be_empty
    expect(response.content_length).to be > 0
    expect(response.content_type).to eq "text/html"
  end

  it 'contains the correct page title'do
    expect(response.body).to include '<title>Digital Repository Contacts - Emory Digital Collections</title>'
  end

  it "contains the requested headers" do
    expect(response.body).to include 'Digital Repository Contacts'
    expect(response.body).to include 'Send Feedback or Report a Problem'
    expect(response.body).to include 'Digital Collections Contacts'
    expect(response.body).to include 'Permissions / Reuse Questions'
  end

  it "contains the needed links" do
    expect(response.body).to include 'feedback form'
    expect(response.body).to include 'https://emory.libwizard.com/f/dlp-feedback'
    expect(response.body).to include 'our wiki site'
    expect(response.body).to include(
      'https://wiki.service.emory.edu/display/DLPP/Emory+Digital+Collections+User+Guide'
    )
    expect(response.body).to include 'rose.library@emory.edu'
    expect(response.body).to include 'mailto:rose.library@emory.edu'
    expect(response.body).to include 'oxarchives@listserv.cc.emory.edu'
    expect(response.body).to include 'mailto:oxarchives@listserv.cc.emory.edu'
  end
end

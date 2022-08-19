# frozen_string_literal: true
require "rails_helper"

RSpec.describe "PURL Redirection", :clean, type: :request do
  before do
    solr = Blacklight.default_index.connection
    solr.add([work_with_public_visibility])
    solr.commit
  end

  let(:public_work_id) { '111-111-cor' }

  let(:work_with_public_visibility) do
    WORK_WITH_PUBLIC_VISIBILITY
  end

  it "redirects requests from /purl/:id to the catalog" do
    get("/purl/#{public_work_id}")
    expect(response).to have_http_status(:see_other)
    expect(response).to redirect_to("/catalog/#{public_work_id}")
  end
end

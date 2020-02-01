
# frozen_string_literal: true
require "rails_helper"
include Warden::Test::Helpers

RSpec.describe "UvConfiguration requests", type: :request do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
  end

  let(:id) { '123' }
  let(:work_attributes) { CURATE_GENERIC_WORK }

  describe "GET /uv/config/:id" do
    it "pulls a Universal Viewer manifest for the resource" do
      get "/uv/config/#{id}", params: { format: :json }

      expect(response.status).to eq 200
      expect(response.body).not_to be_empty
      expect(response.content_length).to be > 0
      expect(response.content_type).to eq "application/json"

      response_values = JSON.parse(response.body)
      expect(response_values).to include "modules"
      expect(response_values["modules"]["footerPanel"]).to include "options"
      expect(response_values["modules"]["footerPanel"]["options"]).to include(
        "shareEnabled" => false,
        "downloadEnabled" => false,
        "fullscreenEnabled" => false
      )
    end

    context "when the resource does not exist" do
      xit "responds with a 404 status code" do
        get "/uv/config/nonexistent", params: { format: :json }

        expect(response.status).to eq 404
      end
    end

    context "when authenticated as a user member" do
      let(:user) { FactoryBot.create(:user) }

      before do
        login_as user
      end

      it "responds with the configuration with downloads enabled" do
        get "/uv/config/#{id}", params: { format: :json }

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "application/json"

        response_values = JSON.parse(response.body)
        expect(response_values).to include "modules"
        expect(response_values["modules"]).to include "footerPanel"
        expect(response_values["modules"]["footerPanel"]).to include "options"
        expect(response_values["modules"]["footerPanel"]["options"]).to include(
          "shareEnabled" => true,
          "downloadEnabled" => true,
          "fullscreenEnabled" => true        )
      end
    end
  end
end


# frozen_string_literal: true
require "rails_helper"
include Warden::Test::Helpers

RSpec.describe "UvConfiguration requests", :clean, type: :request do
  before do
    solr = Blacklight.default_index.connection
    solr.add([
               work_with_public_visibility,
               work_with_public_low_view_visibility,
               work_with_emory_high_visibility,
               work_with_emory_low_visibility
             ])
    solr.commit
  end

  let(:public_work_id) { '222-321' }
  let(:public_low_view_work_id) { '333-321' }
  let(:emory_high_work_id) { '111-321' }
  let(:emory_low_work_id) { '444-321' }

  let(:work_with_public_visibility) do
    {
      id: public_work_id,
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Work with Open Access'],
      edit_access_group_ssim: ["admin"],
      read_access_group_ssim: ["public"],
      visibility_ssi: ['open']
    }
  end

  let(:work_with_public_low_view_visibility) do
    {
      id: public_low_view_work_id,
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Work with Public Low View Resolution'],
      edit_access_group_ssim: ["admin"],
      read_access_group_ssim: ["low_res"],
      visibility_ssi: ['low_res']
    }
  end

  let(:work_with_emory_high_visibility) do
    {
      id: emory_high_work_id,
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Work with Emory High visibility'],
      edit_access_group_ssim: ["admin"],
      read_access_group_ssim: ["registered"],
      visibility_ssi: ['authenticated']
    }
  end

  let(:work_with_emory_low_visibility) do
    {
      id: emory_low_work_id,
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Work with Emory Low visibility'],
      edit_access_group_ssim: ["admin"],
      read_access_group_ssim: ["emory_low"],
      visibility_ssi: ["emory_low"]
    }
  end

  describe "GET /uv/config/:id" do
    context "as an unauthenticated user" do
      it "pulls a Universal Viewer manifest for the resource" do
        get "/uv/config/#{public_work_id}", params: { format: :json }

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "application/json"

        response_values = JSON.parse(response.body)
        expect(response_values).to include "modules"
        expect(response_values["modules"]["pagingHeaderPanel"]["options"]).to include "pagingToggleEnabled" => true
        expect(response_values["modules"]["footerPanel"]).to include "options"
        expect(response_values["modules"]["footerPanel"]["options"]).to include(
          "shareEnabled" => true,
          "downloadEnabled" => true,
          "fullscreenEnabled" => true
        )
      end
      it "responds with downloads disabled for a work with 'Public Low View' visibility" do
        get "/uv/config/#{public_low_view_work_id}", params: { format: :json }

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "application/json"

        response_values = JSON.parse(response.body)
        expect(response_values).to include "modules"
        expect(response_values["modules"]["pagingHeaderPanel"]["options"]).to include "pagingToggleEnabled" => true
        expect(response_values["modules"]["footerPanel"]).to include "options"
        expect(response_values["modules"]["footerPanel"]["options"]).to include(
          "shareEnabled" => false,
          "downloadEnabled" => false,
          "fullscreenEnabled" => false
        )
      end
    end

    context "when the resource does not exist" do
      xit "responds with a 404 status code" do
        get "/uv/config/nonexistent", params: { format: :json }

        expect(response.status).to eq 404
      end
    end

    context "when authenticated as a user" do
      let(:user) { FactoryBot.create(:user) }

      before do
        login_as user
      end

      it "responds with the configuration with downloads enabled for a work with 'Public' visibility" do
        get "/uv/config/#{public_work_id}", params: { format: :json }

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "application/json"

        response_values = JSON.parse(response.body)
        expect(response_values).to include "modules"
        expect(response_values["modules"]["pagingHeaderPanel"]["options"]).to include "pagingToggleEnabled" => true
        expect(response_values["modules"]).to include "footerPanel"
        expect(response_values["modules"]["footerPanel"]).to include "options"
        expect(response_values["modules"]["footerPanel"]["options"]).to include(
          "shareEnabled" => true,
          "downloadEnabled" => true,
          "fullscreenEnabled" => true
        )
      end

      it "responds with downloads disabled for a work with 'Public Low View' visibility" do
        get "/uv/config/#{public_low_view_work_id}", params: { format: :json }

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

      it "responds with downloads enabled for a work with 'Emory High Download' visibility" do
        get "/uv/config/#{emory_high_work_id}", params: { format: :json }

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "application/json"

        response_values = JSON.parse(response.body)
        expect(response_values).to include "modules"
        expect(response_values["modules"]["footerPanel"]).to include "options"
        expect(response_values["modules"]["footerPanel"]["options"]).to include(
          "shareEnabled" => true,
          "downloadEnabled" => true,
          "fullscreenEnabled" => true
        )
      end

      it "responds with downloads enabled for a work with 'Emory Low Download' visibility" do
        get "/uv/config/#{emory_low_work_id}", params: { format: :json }

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "application/json"

        response_values = JSON.parse(response.body)
        expect(response_values).to include "modules"
        expect(response_values["modules"]["footerPanel"]).to include "options"
        expect(response_values["modules"]["footerPanel"]["options"]).to include(
          "shareEnabled" => true,
          "downloadEnabled" => true,
          "fullscreenEnabled" => true
        )
      end
    end
  end
end
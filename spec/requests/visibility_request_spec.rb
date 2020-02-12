
# frozen_string_literal: true
require "rails_helper"
include Warden::Test::Helpers

RSpec.describe "Visibility requests", :clean, type: :request do
  before do
    solr = Blacklight.default_index.connection
    solr.add([
               work_with_public_visibility,
               work_with_public_low_view_visibility,
               work_with_emory_high_visibility,
               work_with_emory_low_visibility,
               work_with_rose_high_visibility,
               work_with_private_visibility
             ])
    solr.commit
    ENV['READING_ROOM_IPS'] = '123.456.1.100 456.789 345.789'
  end

  let(:non_reading_room_ip) { '192.168.1.100' }
  let(:reading_room_ip) { '123.456.1.100' }

  let(:public_work_id) { '222-321' }
  let(:public_low_view_work_id) { '333-321' }
  let(:emory_high_work_id) { '111-321' }
  let(:emory_low_work_id) { '444-321' }
  let(:rose_high_work_id) { '555-321' }
  let(:private_work_id) { '666-321' }

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

  let(:work_with_rose_high_visibility) do
    {
      id: rose_high_work_id,
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Work with Rose High View visibility'],
      edit_access_group_ssim: ["admin"],
      read_access_group_ssim: ["rose_high"],
      visibility_ssi: ['rose_high']
    }
  end

  let(:work_with_private_visibility) do
    {
      id: private_work_id,
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Work with Private visibility'],
      edit_access_group_ssim: ["admin"],
      visibility_ssi: ["restricted"]
    }
  end

  describe "GET /catalog/:id" do
    context "as an unauthenticated user outside the Rose Reading Room" do
      it "loads the 'show' page for a work with 'Public' visibility" do
        get("/catalog/#{public_work_id}")

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "text/html"
      end

      it "loads the 'show' page for a work with 'Public Low View' visibility" do
        get "/catalog/#{public_low_view_work_id}"

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "text/html"
      end

      it "does not load the 'show' page for a work with 'Emory High Download' visibility" do
        get "/catalog/#{emory_high_work_id}"

        expect(response.status).to eq 404
      end

      it "does not load the 'show' page for a work with 'Emory Low Download' visibility" do
        get "/catalog/#{emory_low_work_id}"

        expect(response.status).to eq 404
      end

      it "does not load the 'show' page for a work with 'Rose High View' visibility" do
        get "/catalog/#{rose_high_work_id}"

        expect(response.status).to eq 404
      end

      it "does not load the 'show' page for a work with 'Private' visibility" do
        get "/catalog/#{private_work_id}"

        expect(response.status).to eq 404
      end
    end

    context "when authenticated as a user outside the Rose Reading Room" do
      let(:user) { FactoryBot.create(:user) }

      before do
        login_as user
      end

      it "loads the 'show' page for a work with 'Public' visibility" do
        get "/catalog/#{public_work_id}"

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "text/html"
      end

      it "loads the 'show' page for a work with 'Public Low View' visibility" do
        get "/catalog/#{public_low_view_work_id}"

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "text/html"
      end

      it "loads the 'show' page for a work with 'Emory High Download' visibility" do
        get "/catalog/#{emory_high_work_id}"

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "text/html"
      end

      it "loads the 'show' page for a work with 'Emory Low Download' visibility" do
        get "/catalog/#{emory_low_work_id}"

        expect(response.status).to eq 200
        expect(response.body).not_to be_empty
        expect(response.content_length).to be > 0
        expect(response.content_type).to eq "text/html"
      end

      it "does not load the 'show' page for a work with 'Rose High View' visibility" do
        get "/catalog/#{rose_high_work_id}"
        expect(response.status).to eq 404
      end

      it "does not load the 'show' page for a work with 'Private' visibility" do
        get "/catalog/#{private_work_id}"

        expect(response.status).to eq 404
      end
    end

    context "when in the Rose Reading Room" do
      it "loads the 'show' page for a work with 'Rose High View' visibility" do
        get("/catalog/#{rose_high_work_id}", headers: { "REMOTE_ADDR": reading_room_ip })

        expect(request.headers["REMOTE_ADDR"]).to eq reading_room_ip
        expect(response.status).to eq 200
      end
    end
  end
end


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
  end

  let(:non_reading_room_ip) { '198.51.100.255' }
  let(:reading_room_ip) { '192.0.0.255' }

  let(:emory_high_work_id) { '111-321' }
  let(:public_work_id) { '222-321' }
  let(:public_low_view_work_id) { '333-321' }
  let(:emory_low_work_id) { '444-321' }
  let(:rose_high_work_id) { '555-321' }
  let(:private_work_id) { '666-321' }

  let(:work_with_emory_high_visibility) do
    WORK_WITH_EMORY_HIGH_VISIBILITY
  end

  let(:work_with_public_visibility) do
    WORK_WITH_PUBLIC_VISIBILITY
  end

  let(:work_with_public_low_view_visibility) do
    WORK_WITH_PUBLIC_LOW_VIEW_VISIBILITY
  end

  let(:work_with_emory_low_visibility) do
    WORK_WITH_EMORY_LOW_VISIBILITY
  end

  let(:work_with_rose_high_visibility) do
    WORK_WITH_ROSE_HIGH_VISIBILITY
  end

  let(:work_with_private_visibility) do
    WORK_WITH_PRIVATE_VISIBILITY
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

        # Should redirect to login page
        expect(response.status).to eq 302
      end

      it "does not load the 'show' page for a work with 'Emory Low Download' visibility" do
        get "/catalog/#{emory_low_work_id}"

        # Should redirect to login page
        expect(response.status).to eq 302
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

      it "does not load the 'show' page for a work with 'Rose High View' visibility using remote address" do
        get "/catalog/#{rose_high_work_id}", headers: { "REMOTE_ADDR": non_reading_room_ip }
        expect(response.status).to eq 404
      end

      it "does not load the 'show' page for a work with 'Rose High View' visibility using x-forwarded-for" do
        get "/catalog/#{rose_high_work_id}", headers: { "X-Forwarded-For": non_reading_room_ip }
        expect(response.status).to eq 404
      end

      it "does not load the 'show' page for a work with 'Private' visibility" do
        get "/catalog/#{private_work_id}"

        expect(response.status).to eq 404
      end
    end

    context "when in the Rose Reading Room" do
      it "loads the 'show' page for a work with 'Rose High View' visibility using Remote Address header" do
        get("/catalog/#{rose_high_work_id}", headers: { "REMOTE_ADDR": reading_room_ip })

        expect(request.headers["REMOTE_ADDR"]).to eq reading_room_ip
        expect(response.status).to eq 200
      end

      it "loads the 'show' page for a work with 'Rose High View' visibility using X-Forwarded-For header" do
        get("/catalog/#{rose_high_work_id}", headers: { "X-Forwarded-For": reading_room_ip })

        expect(request.headers["X-Forwarded-For"]).to eq reading_room_ip
        expect(response.status).to eq 200
      end
    end
  end
end

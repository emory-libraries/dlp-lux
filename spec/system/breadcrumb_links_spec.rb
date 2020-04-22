# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Breadcrumb links when viewing assorted pages", type: :system, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
    visit solr_document_path(id)
  end

  context 'when on homepage' do
    let(:work_attributes) { CURATE_GENERIC_WORK }
    let(:id) { '123' }

    it 'has no breadcrumb links' do
      visit '/'

      expect(page).not_to have_css("a.breadcrumb-link")
    end
  end

  context 'when on Collection show page' do
    let(:id) { '119f4qrfj9-cor' }
    let(:work_attributes) { COLLECTION.except(:member_of_collection_ids_ssim) }

    include_examples "check_page_for_link", "Home", "/"
    include_examples "check_page_for_current_link", "Chester W. Topp...", "/catalog/119f4qrfj9-cor"
    include_examples "check_page_for_full_link", "Chester W. Topp collection of Victorian yellowbacks and paperbacks"
  end

  context 'if the Collection has a Parent Collection' do
    let(:id) { '119f4qrfj9-cor' }
    let(:work_attributes) { COLLECTION }

    include_examples "check_page_for_link", "Home", "/"
    include_examples "check_page_for_link", "Back to Parent Object", "/catalog/805fbg79d6-cor"
    include_examples "check_page_for_current_link", "Chester W. Topp...", "/catalog/119f4qrfj9-cor"
  end

  context "when on Collection's Parent Object" do
    let(:id) { '123' }
    let(:work_attributes) { CURATE_GENERIC_WORK }

    include_examples "check_page_for_link", "Home", "/"
    include_examples "check_page_for_link", "Back to Collection", "/catalog/805fbg79d6-cor"
    include_examples "check_page_for_current_link", "The Title of...", "/catalog/123"
    include_examples "check_page_for_full_link", "The Title of my Work"
  end

  context "when on Collection Parent's Child Object" do
    let(:id) { '1010111' }
    let(:work_attributes) do
      CHILD_WORK_WO_COLLECTION_ATTACHED.merge(
        member_of_collections_ssim: ["Emory University Yearbooks"],
        member_of_collection_ids_ssim: ["2150gb5mkr-cor"],
        title_tesim: ['A Sweeping Masterpiece With Epic Scale']
      )
    end

    include_examples "check_page_for_link", "Home", "/"
    include_examples "check_page_for_link", "Back to Collection", "/catalog/2150gb5mkr-cor"
    include_examples "check_page_for_link", "Back to Parent Object", "/catalog/1010110"
    include_examples "check_page_for_current_link", "A Sweeping Masterpiece...", "/catalog/1010111"
    include_examples "check_page_for_full_link", "A Sweeping Masterpiece With Epic Scale"
  end

  context "when on Collection-less Parent Object" do
    let(:id) { '1010110' }
    let(:work_attributes) do
      PARENT_WORK_WO_COLLECTION_ATTACHED.merge(
        title_tesim: 'A Melodramatic, Whining Piece of Pap'
      ).except(:child_works_for_lux_tesim)
    end

    include_examples "check_page_for_link", "Home", "/"
    include_examples "check_page_for_current_link", "A Melodramatic, Whining...", "/catalog/1010110"
    include_examples "check_page_for_full_link", "A Melodramatic, Whining Piece of Pap"
  end

  context "when on Collection-less Child Object" do
    let(:id) { '1010111' }
    let(:work_attributes) { CHILD_WORK_WO_COLLECTION_ATTACHED.merge(title_tesim: 'A Fine Mess') }

    include_examples "check_page_for_link", "Home", "/"
    include_examples "check_page_for_link", "Back to Parent Object", "/catalog/1010110"
    include_examples "check_page_for_current_link", "A Fine Mess", "/catalog/1010111"
  end

  context "when on /about" do
    let(:id) { '123' }
    let(:work_attributes) { CURATE_GENERIC_WORK }

    include_examples "check_page_for_link_static", "Home", "/about"
    include_examples "check_page_for_current_link_static", "About Emory Digital...", "/about"
    include_examples "check_page_for_full_link_static", "About Emory Digital Collections", "/about"
  end

  context "when on /contact" do
    let(:id) { '123' }
    let(:work_attributes) { CURATE_GENERIC_WORK }

    include_examples "check_page_for_link_static", "Home", "/contact"
    include_examples "check_page_for_current_link_static", "Digital Repository Contacts", "/contact"
  end
end

# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "View Works with different levels of visibility", type: :system do
  before do
    solr = Blacklight.default_index.connection
    solr.add([
               work_with_emory_high_visibility,
               work_with_public_visibility,
               work_with_public_low_view_visibility,
               work_with_emory_low_visibility,
               work_with_rose_high_visibility,
               work_with_private_visibility
             ])
    solr.commit
  end

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

  context 'as a guest user' do
    it 'only displays show page if user has at least "read"-level access' do
      # Should see page content
      visit solr_document_path(public_work_id)
      expect(page).to have_content 'Work with Open Access'

      # Should not see page content
      visit solr_document_path(emory_high_work_id)
      expect(page).not_to have_content 'Work with Emory High visibility'
      expect(page).to have_content 'Page Restricted or Not Found'

      # Should see (low res) page content
      visit solr_document_path(public_low_view_work_id)
      expect(page).to have_content('Work with Public Low Resolution')

      # Should not see page content
      visit solr_document_path(emory_low_work_id)
      expect(page).not_to have_content 'Work with Emory Low visibility'
      expect(page).to have_content 'Page Restricted or Not Found'

      # Should not see page content
      visit solr_document_path(rose_high_work_id)
      expect(page).not_to have_content 'Work with Rose High View visibility'
      expect(page).to have_content 'Page Restricted or Not Found'

      # Should not see page content
      visit solr_document_path(private_work_id)
      expect(page).not_to have_content 'Work with Private visibility'
      expect(page).to have_content 'Page Restricted or Not Found'
    end
  end

  context 'as a logged in user' do
    let(:user) { FactoryBot.create(:user) }
    before do
      login_as user
    end
    it 'only displays show page if user has at least "read"-level access' do
      # Should see page content
      visit solr_document_path(public_work_id)
      expect(page).to have_content 'Work with Open Access'

      # Should see page content
      visit solr_document_path(emory_high_work_id)
      expect(page).to have_content 'Work with Emory High visibility'
      expect(page).not_to have_content 'Page Restricted or Not Found'

      # Should see (low res) page content
      visit solr_document_path(public_low_view_work_id)
      expect(page).to have_content('Work with Public Low Resolution')

      # Should see (low res) page content
      visit solr_document_path(emory_low_work_id)
      expect(page).to have_content('Work with Emory Low visibility')

      # Should not see page content
      visit solr_document_path(rose_high_work_id)
      expect(page).not_to have_content 'Work with Rose High View visibility'
      expect(page).to have_content 'Page Restricted or Not Found'

      # Should not see page content
      visit solr_document_path(private_work_id)
      expect(page).not_to have_content 'Work with Private visibility'
      expect(page).to have_content 'Page Restricted or Not Found'
    end
  end
end

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
               work_with_emory_low_visibility
             ])
    solr.commit
  end
  let(:emory_high_work_id) { '111-321' }
  let(:public_work_id) { '222-321' }
  let(:public_low_view_work_id) { '333-321' }
  let(:emory_low_work_id) { '444-321' }

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
      title_tesim: ['Work with Public Low Resolution'],
      edit_access_group_ssim: ["admin"],
      read_access_group_ssim: ["low_res"],
      visibility_ssi: ['low_res']
    }
  end

  let(:work_with_emory_low_visibility) do
    {
      id: emory_low_work_id,
      has_model_ssim: ['CurateGenericWork'],
      title_tesim: ['Work with Emory Low visibility'],
      edit_access_group_ssim: ["admin"],
      read_access_group_ssim: ["emory_low"]
    }
  end

  context 'as a guest user' do
    it 'only displays show page if user has at least "read"-level access' do
      # Should see page content
      visit solr_document_path(public_work_id)
      expect(page).to have_content 'Work with Open Access'

      # Should not see page content
      visit solr_document_path(emory_high_work_id)
      expect(page).not_to have_content 'Work with Emory High visibility'
      expect(page).to have_content 'Custom 404 page'

      # Should see (low res) page content
      visit solr_document_path(public_low_view_work_id)
      expect(page).to have_content('Work with Public Low Resolution')

      # Should not see page content
      visit solr_document_path(emory_low_work_id)
      expect(page).not_to have_content 'Work with Emory Low visibility'
      expect(page).to have_content 'Custom 404 page'
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
      expect(page).not_to have_content 'Custom 404 page'

      # Should see (low res) page content
      visit solr_document_path(public_low_view_work_id)
      expect(page).to have_content('Work with Public Low Resolution')

      # Should see (low res) page content
      visit solr_document_path(emory_low_work_id)
      expect(page).to have_content('Work with Emory Low visibility')
    end
  end
end

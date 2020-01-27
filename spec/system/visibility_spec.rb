# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "View a Work with Emory High Resolution visibility", js: true do
  context 'as a guest user' do
    before do
      solr = Blacklight.default_index.connection
      solr.add([work_with_emory_high_visibility, work_with_open_visibility])
      solr.commit
    end

    let(:emory_high_work_id) { '111-321' }
    let(:open_work_id) { '222-321' }

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

    let(:work_with_open_visibility) do
      {
        id: open_work_id,
        has_model_ssim: ['CurateGenericWork'],
        title_tesim: ['Work with Open Access'],
        edit_access_group_ssim: ["admin"],
        read_access_group_ssim: ["public"]
      }
    end

    let(:css_selector_for_uv) { '.uv-container' }

    it 'only displays Universal Viewer if user has at least "read"-level access' do
      # Should see Universal Viewer
      visit solr_document_path(open_work_id)
      expect(page).to have_selector(css_selector_for_uv)

      # Shouldn't see Universal Viewer
      visit solr_document_path(emory_high_work_id)
      expect(page).not_to have_selector(css_selector_for_uv)
    end
  end
  context 'as a logged in user' do
    let(:user) { FactoryBot.create(:user) }

    before do
      login_as user
      solr = Blacklight.default_index.connection
      solr.add([work_with_emory_high_visibility, work_with_open_visibility])
      solr.commit
    end

    let(:emory_high_work_id) { '111-321' }
    let(:open_work_id) { '222-321' }

    let(:work_with_emory_high_visibility) do
      {
        id: emory_high_work_id,
        has_model_ssim: ['CurateGenericWork'],
        title_tesim: ['Work with Emory Low visibility'],
        edit_access_group_ssim: ["admin"],
        read_access_group_ssim: ["registered"],
        visibility_ssi: ['authenticated']
      }
    end

    let(:work_with_open_visibility) do
      {
        id: open_work_id,
        has_model_ssim: ['CurateGenericWork'],
        title_tesim: ['Work with Open Access'],
        edit_access_group_ssim: ["admin"],
        read_access_group_ssim: ["public"]
      }
    end

    let(:css_selector_for_uv) { '.uv-container' }

    it 'only displays Universal Viewer if user has at least "read"-level access' do
      # Should see Universal Viewer
      visit solr_document_path(open_work_id)
      expect(page).to have_selector(css_selector_for_uv)

      # Shouldn't see Universal Viewer
      visit solr_document_path(emory_high_work_id)
      expect(page).to have_selector(css_selector_for_uv)
    end
  end
end

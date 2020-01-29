# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "View a Work with Emory High Resolution visibility", type: :system, js: true do
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
      read_access_group_ssim: ["public"],
      visibility_ssi: ['open']
    }
  end

  context 'as a guest user' do
    it 'only displays show page if user has at least "read"-level access' do
      # Should see page content
      visit solr_document_path(open_work_id)
      expect(page).to have_content 'Work with Open Access'

      # Should not see page content
      visit solr_document_path(emory_high_work_id)
      expect(page).not_to have_content 'Work with Emory High visibility'
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
      visit solr_document_path(open_work_id)
      expect(page).to have_content 'Work with Open Access'

      # Should see page content
      visit solr_document_path(emory_high_work_id)
      expect(page).to have_content 'Work with Emory High visibility'
      expect(page).not_to have_content 'Custom 404 page'
    end
  end
end

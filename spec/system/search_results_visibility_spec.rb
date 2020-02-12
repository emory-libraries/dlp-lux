# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "View Works with different levels of visibility", clean: true, type: :system do
  before do
    delete_all_documents_from_solr
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
    visit "/"

    click_on 'Search'
  end

  let(:emory_high_work_id) { '111-321' }
  let(:public_work_id) { '222-321' }
  let(:public_low_view_work_id) { '333-321' }
  let(:emory_low_work_id) { '444-321' }
  let(:rose_high_work_id) { '555-321' }
  let(:private_work_id) { '666-321' }

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


  it 'shows search results for all except private works' do
    expect(page).to have_content 'Work with Open Access'
    expect(page).to have_content 'Work with Emory High visibility'
    expect(page).to have_content 'Work with Public Low Resolution'
    expect(page).to have_content 'Work with Emory Low visibility'
    expect(page).to have_content 'Work with Rose High View visibility'

    expect(page).not_to have_content 'Work with Private visibility'
  end
end

# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe "View search results for works with different levels of visibility", js: false, clean: true, type: :system do
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
    click_on('search')
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

  it 'shows search results for all except private works' do
    expect(page).to have_content 'Work with Open Access'
    expect(page).to have_content 'Work with Emory High visibility'
    expect(page).to have_content 'Work with Public Low Resolution'
    expect(page).to have_content 'Work with Emory Low visibility'
    expect(page).to have_content 'Work with Rose High View visibility'

    expect(page).not_to have_content 'Work with Private visibility'
  end
end

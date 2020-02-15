# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Facet the catalog by visibility', type: :system, js: true do
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

  it 'limits to Public objects using facet' do
    visit root_path
    click_on 'search'

    within '#documents' do
      expect(page).to     have_content('Work with Emory High visibility')
      expect(page).to     have_content('Work with Open Access')
      expect(page).to     have_content('Work with Public Low Resolution')
      expect(page).to     have_content('Work with Emory Low visibility')
      expect(page).to     have_content('Work with Rose High View visibility')

      expect(page).not_to have_content('Work with Private visibility')
    end

    click_on 'Access'
    click_link("Public", href: '/?f%5Bvisibility_group_ssi%5D%5B%5D=Public&q=&search_field=common_fields')

    expect(page).to     have_content('Work with Open Access')
    expect(page).to     have_content('Work with Public Low Resolution')
    expect(page).not_to have_content('Work with Emory Low visibility')
    expect(page).not_to have_content('Work with Emory High visibility')
    expect(page).not_to have_content('Work with Rose High View visibility')
    expect(page).not_to have_content('Work with Private visibility')
  end

  it 'limits to "Log In Required" objects using facet' do
    visit root_path
    click_on 'search'

    within '#documents' do
      expect(page).to     have_content('Work with Emory High visibility')
      expect(page).to     have_content('Work with Open Access')
      expect(page).to     have_content('Work with Public Low Resolution')
      expect(page).to     have_content('Work with Emory Low visibility')
      expect(page).to     have_content('Work with Rose High View visibility')

      expect(page).not_to have_content('Work with Private visibility')
    end

    click_on 'Access'
    click_on 'Log In Required'

    within '#documents' do
      expect(page).not_to have_content('Work with Open Access')
      expect(page).not_to have_content('Work with Public Low Resolution')
      expect(page).to     have_content('Work with Emory Low visibility')
      expect(page).to     have_content('Work with Emory High visibility')
      expect(page).not_to have_content('Work with Rose High View visibility')
      expect(page).not_to have_content('Work with Private visibility')
    end
  end

  it 'limits to "Reading Room Specific" objects using facet' do
    visit root_path
    click_on 'search'

    within '#documents' do
      expect(page).to     have_content('Work with Emory High visibility')
      expect(page).to     have_content('Work with Open Access')
      expect(page).to     have_content('Work with Public Low Resolution')
      expect(page).to     have_content('Work with Emory Low visibility')
      expect(page).to     have_content('Work with Rose High View visibility')

      expect(page).not_to have_content('Work with Private visibility')
    end

    click_on 'Access'
    click_on 'Reading Room Specific'

    within '#documents' do
      expect(page).not_to have_content('Work with Open Access')
      expect(page).not_to have_content('Work with Public Low Resolution')
      expect(page).not_to have_content('Work with Emory Low visibility')
      expect(page).not_to have_content('Work with Emory High visibility')
      expect(page).to     have_content('Work with Rose High View visibility')
      expect(page).not_to have_content('Work with Private visibility')
    end
  end
end

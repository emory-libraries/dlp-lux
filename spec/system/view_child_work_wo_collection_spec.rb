# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "View a child Work not attached to a collection", type: :system, js: false do
  before do
    solr = Blacklight.default_index.connection
    solr.add([PARENT_WORK_WO_COLLECTION_ATTACHED, CHILD_WORK_WO_COLLECTION_ATTACHED])
    solr.commit
    visit solr_document_path(child_work_id)
  end

  let(:parent_work_id) { PARENT_WORK_WO_COLLECTION_ATTACHED[:id] }
  let(:child_work_id) { CHILD_WORK_WO_COLLECTION_ATTACHED[:id] }

  it 'does have the uv html on the page' do
    expect(page.html).to match(/universal-viewer-iframe/)
  end

  it 'does not link any Collection' do
    expect(page).not_to have_css('dd.blacklight-member_of_collections')
  end

  it 'links the parent work in is_part_of' do
    expect(page).to have_css('dd.blacklight-parent_member_of_collections')
    expect(page).to have_link('Random Work', href: '1010110')
  end
end

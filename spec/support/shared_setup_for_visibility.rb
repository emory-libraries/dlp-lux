# frozen_string_literal: true

RSpec.shared_context('setup common visibility solr documents') do
  before do
    delete_all_documents_from_solr
    solr = Blacklight.default_index.connection
    solr.add([
               work_with_public_visibility,
               work_with_public_low_view_visibility,
               work_with_emory_high_visibility,
               work_with_emory_low_visibility,
               work_with_rose_high_visibility,
               work_with_irish_partner_visibility,
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
  let(:irish_partner_work_id) { '777-321' }
  let(:work_with_public_visibility) { WORK_WITH_PUBLIC_VISIBILITY }
  let(:work_with_public_low_view_visibility) { WORK_WITH_PUBLIC_LOW_VIEW_VISIBILITY }
  let(:work_with_emory_high_visibility) { WORK_WITH_EMORY_HIGH_VISIBILITY }
  let(:work_with_emory_low_visibility) { WORK_WITH_EMORY_LOW_VISIBILITY }
  let(:work_with_rose_high_visibility) { WORK_WITH_ROSE_HIGH_VISIBILITY }
  let(:work_with_irish_partner_visibility) { WORK_WITH_IRISH_PARTNER_VISIBILITY }
  let(:work_with_private_visibility) { WORK_WITH_PRIVATE_VISIBILITY }
end

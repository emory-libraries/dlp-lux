# frozen_string_literal: true

class EmoryPersistentIdSearchBuilder < ::SearchBuilder
  # You only need to add one method to the chain now
  self.default_processor_chain += [:find_single_document_by_persistent_id]

  def find_single_document_by_persistent_id(solr_parameters)
    target_id = blacklight_params[:emory_persistent_id]

    if target_id.present?
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << "{!field f=emory_persistent_id_ssi}#{target_id}"
      solr_parameters[:rows] = 1
    end
  end
end

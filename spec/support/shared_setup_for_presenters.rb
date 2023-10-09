# frozen_string_literal: true

RSpec.shared_context("with parsed terms") do |obj_type = nil, terms_sym = nil|
  let(:obj_type_parsed) { obj_type == 'work' ? CURATE_GENERIC_WORK : COLLECTION }
  let(:passed_terms_sym) { terms_sym }
  let(:document) { SolrDocument.new(obj_type_parsed) }
  let(:doc_presenter) { Blacklight::ShowPresenter.new(document, CatalogController.new.view_context) }
  let(:pres) { described_class.new(document: doc_presenter.fields_to_render) }
  let(:pres_terms) { passed_terms_sym.present? ? pres.terms(passed_terms_sym) : pres.terms }
end

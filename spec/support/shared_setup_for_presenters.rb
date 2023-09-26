# frozen_string_literal: true

RSpec.shared_context("with parsed terms") do |obj_type = nil, terms_sym = nil|
  let(:obj_type_parsed) { obj_type == 'work' ? CURATE_GENERIC_WORK : COLLECTION }
  let(:passed_terms_sym) { terms_sym }
  let(:document) { SolrDocument.new(obj_type_parsed) }
  let(:show_fields) { CatalogController.new.blacklight_config.show_fields }
  let(:doc_enum) do
    show_fields.map do |name, field_config|
      field_presenter = Blacklight::FieldPresenter.new(nil, document, field_config, {})

      next unless field_presenter.any? && name.present?

      [name, field_config, field_presenter]
    end.compact.to_enum
  end
  let(:pres) { described_class.new(document: doc_enum) }
  let(:pres_terms) { passed_terms_sym.present? ? pres.terms(passed_terms_sym) : pres.terms }
end

# frozen_string_literal: true
module FindThisItemHelper
  def find_item_field_label(document, field_name)
    render_document_show_field_label document, field: field_name
  end

  def find_item_field_value(doc_presenter, field, field_name)
    return doc_presenter.field_value field unless field_name == "id"
    link_to purl(doc_presenter.field_value(field)), purl(doc_presenter.field_value(field))
  end
end

# frozen_string_literal: true
module AdditionalCatalogHelper
  include NewspaperWorks::NewspaperWorksHelperBehavior

  def purl(doc_id)
    "https://digital.library.emory.edu/purl/#{doc_id}"
  end

  def field_is_for_dates?(field_name)
    field_name.include? "date"
  end

  def dates_on_separate_lines(document, field_name)
    document[field_name].join("<br>")
  end
end

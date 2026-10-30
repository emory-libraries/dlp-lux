# frozen_string_literal: true
module AdditionalCatalogHelper
  include NewspaperWorks::NewspaperWorksHelperBehavior

  def purl(doc_id)
    base_url = ENV.fetch("LUX_BASE_URL", "http://localhost:3000")
    "#{base_url}/purl/#{doc_id}"
  end

  def field_is_for_dates?(field_name)
    field_name.include? "date"
  end

  def dates_on_separate_lines(document, field_name)
    document[field_name].join("<br>")
  end
end

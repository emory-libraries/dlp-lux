# frozen_string_literal: true
module AdditionalCatalogHelper
  def purl(doc_id)
    "https://digital.library.emory.edu/purl/#{doc_id}"
  end

  def field_is_for_dates?(field_name)
    [
      'human_readable_date_created_tesim',
      'human_readable_date_issued_tesim',
      'human_readable_data_collection_dates_tesim',
      'human_readable_conference_dates_tesim',
      'human_readable_copyright_date_tesim'
    ].any? { |date_field| date_field == field_name }
  end

  def dates_on_separate_lines(document, field_name)
    document[field_name].join("<br>")
  end
end

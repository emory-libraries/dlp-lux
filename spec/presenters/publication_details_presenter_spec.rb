# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PublicationDetailsPresenter do
  include_context('with parsed terms', 'work')
  let(:expected_terms) do
    { 'publisher_tesim' => ['New York Labor News Company'],
      'final_published_versions_tesim' => ['https://final_version.com'],
      'publisher_version_tesim' => ['https://publisher_version.com'],
      'place_of_production_tesim' => ['Carrboro, NC'],
      'volume_tesim' => ['1'],
      'edition_tesim' => ['3rd ed.'],
      'issue_tesim' => ['224'],
      'page_range_start_tesim' => ['iii'],
      'page_range_end_tesim' => ['501'],
      'issn_tesim' => ['0044-8399'],
      'isbn_tesim' => ['9780415364256'] }
  end

  include_examples('tests for expected terms')
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SubjectsKeywordsPresenter do
  include_context('with parsed terms', 'work')
  let(:expected_terms) do
    { "subject_topics_tesim" => ['A topic for a subject'],
      "subject_names_tesim" => ['Qāsimlū, Mujtabá'],
      "subject_geo_tesim" => ['New Jersey'],
      "subject_time_periods_tesim" => ['Edo (African)'],
      "keywords_tesim" => ['key', 'words'] }
  end

  context 'with a solr document, #terms' do
    include_examples 'tests for expected terms'
  end
end

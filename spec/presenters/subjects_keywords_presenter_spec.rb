# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SubjectsKeywordsPresenter, run_in_ci: true do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:subjects_terms) do
    { subject_topics_tesim: ['A topic for a subject'],
      subject_names_tesim: ['Qāsimlū, Mujtabá'],
      subject_geo_tesim: ['New Jersey'],
      subject_time_periods_tesim: ['Edo (African)'],
      keywords_tesim: ['key', 'words'] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(subjects_terms)
      end
    end
  end
end

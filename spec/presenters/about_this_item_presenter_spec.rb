# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AboutThisItemPresenter do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:about_terms) do
    { uniform_title_tesim: ['This is a uniform title'],
      series_title_tesim: ['This is a series title'],
      parent_title_tesim: ['This is a parent title'],
      creator_tesim: ['Smith, Somebody'],
      contributors_tesim: ['Contributor, Jack'],
      human_readable_date_created_tesim: ['1776', 'unknown', '1920s', '1973 approx.'],
      human_readable_date_issued_tesim: ['1652'],
      data_collection_dates_tesim: ['1985'],
      human_readable_content_type_ssim: ['Text'],
      content_genres_tesim: ['Painting'],
      extent_tesim: ['152 p., [50] leaves of plates'],
      primary_language_tesim: ['English'],
      notes_tesim: ['notes about a thing'],
      abstract_tesim: ['Description or abstract of work'],
      table_of_contents_tesim: ['Table of contents, Here\'s another content'] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(about_terms)
      end
    end
  end
end

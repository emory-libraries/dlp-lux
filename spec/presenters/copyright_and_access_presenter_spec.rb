# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AccessAndCopyrightPresenter do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:copyright_terms) do
    { rights_holders_tesim: ['Owned by Jamie'],
      human_readable_copyright_date_tesim: ['2027'],
      human_readable_re_use_license_tesim: ['Creative Commons BY Attribution 4.0 International'],
      access_restriction_notes_tesim: ['You can access this only in the Rose reading room, alternate Thursdays.'] }
  end
  context 'with a solr document' do
    describe '#terms' do
      it 'has the correct terms' do
        expect(pres.terms).to eq(copyright_terms)
      end
    end
  end
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CopyrightAndAccessPresenter do
  let(:pres) { described_class.new(document: CURATE_GENERIC_WORK) }
  let(:copyright_terms) do
    { emory_rights_statements_tesim: ['Srsly, y\'all, don\'t copy this.'],
      rights_statement_tesim: ['So copywritten you wouldn\'t dream of copying it.'],
      rights_holders_tesim: ['Owned by Jamie'],
      copyright_date_tesim: ['2027'],
      re_use_license_tesim: ['You can copy this as long as you give credit'],
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

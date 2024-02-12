# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::ShowUvComponent, type: :component do
  # stub variables without presenter options
  include_context('setup common component variables', false)
  let(:doc) { SolrDocument.new(COLLECTION) }
  let(:instance) { described_class.new(doc_id: doc.id, request_base_url: 'base_application.com') }

  before do
    allow(Rails.application.config).to receive(:iiif_url).and_return('https://example.com')
  end

  it 'has the expected elements' do
    expect(render.css('.uv-container')).to be_present
    expect(render.css('.universal-viewer-iframe').first.attributes['src'].value)
      .to eq("base_application.com/uv/uv.html#?manifest=https://example.com/#{doc.id}/manifest")
  end
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::ShowAllMetadataComponent, type: :component do
  # stub variables without presenter options
  include_context('setup common component variables', false)
  let(:doc) { SolrDocument.new(COLLECTION) }

  it 'calls the expected components' do
    with_controller_class CatalogController do
      expect(::Lux::Metadata::FirstColumnComponent).to receive(:new).with(document: doc)
      expect(::Lux::Metadata::SecondColumnComponent).to receive(:new).with(document: doc)
      expect(::Lux::Metadata::ThirdColumnComponent).to receive(:new).with(document: doc)
      expect(::Lux::Metadata::MobileComponent).to receive(:new).with(document: doc)

      render
    end
  end
end

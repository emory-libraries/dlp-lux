# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::ShowDocumentComponent, type: :component do
  # stub variables without presenter options
  include_context('setup common component variables', false)
  let(:doc) { SolrDocument.new(COLLECTION) }
  let(:instance) { described_class.new(document: doc, request_base_url: '/') }
  let(:banner_solr_doc) { SolrDocument.new(COLLECTION.merge(banner_path_ss: '/branding/119f4qrfj9-cor/banner/banner.jpg')) }

  it 'calls the expected components' do
    with_controller_class CatalogController do
      expect(::Lux::ShowAllMetadataComponent).to receive(:new).with(document: doc)

      render
    end
  end

  context '#show_nothing_tester' do
    it('is true with COLLECTION') { expect(instance.show_nothing_tester).to be_truthy }

    context 'with a banner' do
      let(:doc) { banner_solr_doc }

      it('is false when a banner_path is present') { expect(instance.show_nothing_tester).to be_falsey }
    end
  end

  context '#show_banner_tester' do
    it('is false with COLLECTION') { expect(instance.show_banner_tester).to be_falsey }

    context 'with a banner' do
      let(:doc) { banner_solr_doc }

      it('is true when a banner_path is present') { expect(instance.show_banner_tester).to be_truthy }
    end
  end

  context '#banner_source' do
    let(:doc) { banner_solr_doc }

    it 'returns a batther path when set' do
      expect(instance.banner_source).to eq('/branding/119f4qrfj9-cor/banner/banner.jpg')
    end
  end
end

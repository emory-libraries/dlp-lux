# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::BreadcrumbsComponent, type: :component do
  subject(:render) { render_inline(instance) }

  # One passed document example is provided here to ensure component can process it.
  #   There is more extensive testing for breadcrumbs that are passed documents in
  #   spec/system/breadcrumb_links_spec.rb
  context 'with passed document' do
    let(:instance) { described_class.new(document:) }

    context 'of a collection within a parent collection' do
      let(:document) { SolrDocument.new(COLLECTION) }

      include_examples "check_page_for_link", "Home", "/", 'component'
      include_examples "check_page_for_link", "Back to Parent Object", "/catalog/805fbg79d6-cor", 'component'
      include_examples "check_page_for_current_link", "Chester W. Topp...", "/catalog/119f4qrfj9-cor", 'component'
    end

    context 'of a work within a work within a collection' do
      let(:document) { SolrDocument.new(CHILD_CURATE_GENERIC_WORK_1) }

      include_examples "check_page_for_link", "Home", "/", 'component'
      include_examples "check_page_for_link", "Back to Collection", "/catalog/2150gb5mkr-cor", 'component'
      include_examples "check_page_for_link", "Back to Parent Object", "/catalog/030prr4xkj-cor", 'component'
      include_examples "check_page_for_current_link", "Emocad. [1924]", "/catalog/423612jm8k-cor", 'component'
    end

    context 'of a work with no parent work but in a collection' do
      let(:document) { SolrDocument.new(PARENT_CURATE_GENERIC_WORK) }

      include_examples "check_page_for_link", "Home", "/", 'component'
      include_examples "check_page_for_link", "Back to Collection", "/catalog/0278sf7m0d-cor", 'component'
      include_examples "check_page_for_current_link", "Emocad.", "/catalog/030prr4xkj-cor", 'component'
    end

    context 'of a work within a work with no collection' do
      let(:document) { SolrDocument.new(CHILD_WORK_WO_COLLECTION_ATTACHED) }

      include_examples "check_page_for_link", "Home", "/", 'component'
      include_examples "check_page_for_link", "Back to Parent Object", "/catalog/1010110", 'component'
      include_examples "check_page_for_current_link", "A Masterpiece", "/catalog/1010111", 'component'
    end

    context 'of an object with no parent' do
      let(:document) { SolrDocument.new(PARENT_WORK_WO_COLLECTION_ATTACHED) }

      include_examples "check_page_for_link", "Home", "/", 'component'
      include_examples "check_page_for_current_link", "Random Work", "/catalog/1010110", 'component'
    end
  end

  context 'with no passed document but with crumb hashes' do
    let(:instance) { described_class.new(crumb_hashes:) }
    let(:crumb_hashes) { [{ curr_page: true, abbr: nil, link: '/advanced', title: "Advanced Search" }] }

    include_examples "check_page_for_link", "Home", "/", 'component'
    include_examples "check_page_for_current_link", "Advanced Search", "/advanced", 'component'
  end
end

# frozen_string_literal: true
# Blacklight::Document::CitationComponent v7.33.1 Override - use our logic instead
require 'rails_helper'

RSpec.describe Lux::BreadcrumbsComponent, type: :component do
  subject(:render) { render_inline(instance) }

  # One passed document example is provided here to ensure component can process it.
  #   There is more extensive testing for breadcrumbs that are passed documents in
  #   spec/system/breadcrumb_links_spec.rb
  context 'with passed document' do
    let(:instance) { described_class.new(document:) }
    let(:document) { SolrDocument.new(COLLECTION) }

    include_examples "check_page_for_link", "Home", "/", 'component'
    include_examples "check_page_for_link", "Back to Parent Object", "/catalog/805fbg79d6-cor", 'component'
    include_examples "check_page_for_current_link", "Chester W. Topp...", "/catalog/119f4qrfj9-cor", 'component'
  end

  context 'with no passed document but with crumb hashes' do
    let(:instance) { described_class.new(crumb_hashes:) }
    let(:crumb_hashes) { [{ curr_page: true, abbr: nil, link: '/advanced', title: "Advanced Search" }] }

    include_examples "check_page_for_link", "Home", "/", 'component'
    include_examples "check_page_for_current_link", "Advanced Search", "/advanced", 'component'
  end
end

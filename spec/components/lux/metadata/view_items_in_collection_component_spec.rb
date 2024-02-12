# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::ViewItemsInCollectionComponent, type: :component do
  include_context('setup common component variables', false)
  let(:doc) { SolrDocument.new(COLLECTION) }

  it 'has a link with a solr search using collection title' do
    expect(render).to have_link(
      'View items in this digital collection',
      href: '/?f%5Bsource_collection_title_ssim%5D%5B%5D=Chester+W.+Topp+collection+of+Victorian+yellowbacks+and+paperbacks&per_page=10'
    )
  end
end

# frozen_string_literal: true
require 'rails_helper'
require './db/concerns/default_explore_collections'

RSpec.describe Lux::ExploreCollectionsComponent, type: :component do
  include ::DefaultExploreCollections

  subject(:render) { render_inline(instance) }
  let(:instance) { described_class.new }
  before { stub_default_explore_collections }

  it 'produces three default collections' do
    expect(instance.collections.size).to eq(3)
    expect(render.css('.tile-listing').size).to eq(3)
  end

  include_examples('tests for object link', 'Explore Our Collections',
                   '/catalog?f%5Bhas_model_ssim%5D%5B%5D=Collection&f%5Bvisibility_ssi%5D%5B%5D=open')
  include_examples('tests for object link', 'Health Sciences Center Library Artifact Collection',
                   'https://digital.library.emory.edu/catalog/5053ffbg7n-cor')
  include_examples('tests for object link', 'Robert Langmuir African American Photograph Collection',
                   'https://digital.library.emory.edu/catalog/914nk98sfv-cor')
  include_examples('tests for object link', 'Oxford College Collection of Asian Artifacts',
                   'https://digital.library.emory.edu/catalog/320sqv9s4v-cor')
  include_examples('tests for object link', 'View Collection',
                   'https://digital.library.emory.edu/catalog/5053ffbg7n-cor')
  include_examples('tests for object link', 'View Collection',
                   'https://digital.library.emory.edu/catalog/914nk98sfv-cor')
  include_examples('tests for object link', 'View Collection',
                   'https://digital.library.emory.edu/catalog/320sqv9s4v-cor')

  include_examples('test for object images',
                   'https://curate.library.emory.edu//branding/320sqv9s4v-cor/banner/OXKOBE_045_P0001.jpg',
                   'Oxford College Collection of Asian Artifacts')
  include_examples('test for object images',
                   'https://curate.library.emory.edu//branding/914nk98sfv-cor/banner/40644j0ztx-cor.jpg',
                   'Robert Langmuir African American Photograph Collection')
  include_examples('test for object images',
                   'https://curate.library.emory.edu//branding/5053ffbg7n-cor/banner/HS-S023_B067_P004.jpg',
                   'Health Sciences Center Library Artifact Collection')
end

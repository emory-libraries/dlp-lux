# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::Metadata::ThisItemContainsComponent, type: :component do
  include_context('setup common component variables', false)
  let(:doc) { SolrDocument.new(PARENT_CURATE_GENERIC_WORK) }

  it 'has 4 card links' do
    expect(render.css('.card-body dd a').size).to eq(4)
    [{ id: '423612jm8k-cor', title: 'Emocad. [1924]' },
     { id: '631cjsxkvx-cor', title: 'Emocad. [1925]' },
     { id: '0859cnp5kv-cor', title: 'Emocad. [1926]' },
     { id: '85370rxwgx-cor', title: 'Emocad. [1928]' }].each do |child|
      expect(render).to have_link(child[:title], href: child[:id])
    end
  end

  it 'has 4 images with the right sources' do
    ['/downloads/020fttdz2x-cor?file=thumbnail', '/downloads/0343r2282s-cor?file=thumbnail',
     '/downloads/211kh1895r-cor?file=thumbnail', '/downloads/293gxd256t-cor?file=thumbnail']
      .each { |path| expect(render).to have_css("img[src*='#{path}']") }
  end
end

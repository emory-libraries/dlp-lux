# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lux::HeroImageComponent, type: :component do
  subject(:render) { render_inline(instance) }
  let(:instance) { described_class.new }

  it 'loads the expected amount of images' do
    expect(instance.image1).to be_present
    expect(instance.remaining_images.size).to eq(7)
    expect(render.css('.carousel-item').size).to eq(8)
  end

  ::HeroImagePresenter.new.images.each do |image|
    include_examples('tests for object link', 'View Featured Item',
                   image['path'])

    it 'finds the expected image element' do
      expect(render.css("img[alt='#{image['name']}']")).to be_present
    end
  end
end

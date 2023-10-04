# frozen_string_literal: true
# Blacklight v7.33.1 Override - ensures that normal search function is working after our changes.
require 'rails_helper'

RSpec.describe Blacklight::StartOverButtonComponent, type: :component do
  subject(:render) { render_inline(instance) }

  let(:instance) { described_class.new }
  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.view = { list: nil, abc: nil }
    end
  end

  before do
    allow(controller).to receive(:blacklight_config).and_return(blacklight_config)
  end

  context 'with the current view type' do
    before do
      controller.params[:view] = 'abc'
    end

    it 'is the catalog path' do
      expect(render.css('a').first['href']).to eq '/catalog?view=abc'
    end
  end

  context 'when the current view type is the default' do
    before do
      controller.params[:view] = 'list'
    end

    it 'does not include the current view type' do
      expect(render.css('a').first['href']).to eq '/catalog'
    end
  end
end

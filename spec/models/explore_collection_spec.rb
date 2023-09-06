# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ExploreCollection do
  let(:title) { 'good title' }
  let(:banner_path) { 'http://good.bannerpath.com' }
  let(:collection_path) { 'http://good.collectionpath.com' }
  let(:description) { "This is a good description, itn't it?" }

  it 'sets active to true as default' do
    explore_collection = described_class.create(title:, banner_path:, collection_path:, description:)
    expect(explore_collection.active).to be_truthy
  end

  context 'presence validation' do
    it 'makes sure title has value' do
      explore_collection = described_class.new(banner_path:, collection_path:, description:)
      expect(explore_collection.valid?).to be_falsey
    end

    it 'makes sure banner_path has value' do
      explore_collection = described_class.new(title:, collection_path:, description:)
      expect(explore_collection.valid?).to be_falsey
    end

    it 'makes sure collection_path has value' do
      explore_collection = described_class.new(banner_path:, title:, description:)
      expect(explore_collection.valid?).to be_falsey
    end

    it 'makes sure description has value' do
      explore_collection = described_class.new(banner_path:, collection_path:, title:)
      expect(explore_collection.valid?).to be_falsey
    end
  end
end

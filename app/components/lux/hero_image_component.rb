# frozen_string_literal: true

module Lux
  class HeroImageComponent < Blacklight::Component
    attr_reader :image1, :remaining_images

    def initialize
      images = ::HeroImagePresenter.new.images
      @image1 = images.first
      @remaining_images = images.drop(1)
    end
  end
end

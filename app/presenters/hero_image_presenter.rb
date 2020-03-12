# frozen_string_literal: true

class HeroImagePresenter
  attr_reader :config

  def initialize
    @config = YAML.safe_load(File.open(Rails.root.join('config', 'hero_images.yml')))
  end

  def images
    @images = @config['hero_images']
  end
end

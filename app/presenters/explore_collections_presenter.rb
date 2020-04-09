# frozen_string_literal: true

class ExploreCollectionsPresenter
  attr_reader :config

  def initialize
    @config = YAML.safe_load(File.open(Rails.root.join('config', 'explore_collections.yml')))
  end

  def collections
    @collections = @config['collections']
  end
end

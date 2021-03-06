# frozen_string_literal: true

class AboutThisItemPresenter
  attr_reader :document, :config

  def initialize(document:)
    @document = document
    @config = YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'about_this_item.yml')))
  end

  def terms
    @config = @config.symbolize_keys
    @document.slice(*@config.keys)
  end
end

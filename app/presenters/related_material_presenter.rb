# frozen_string_literal: true

class RelatedMaterialPresenter
  attr_reader :document, :config

  def initialize(document:)
    @document = document
    @config = YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'related_material.yml')))
  end

  def terms
    config_keys = @config.keys
    @document.to_a.select { |field| config_keys.include? field.first }.to_enum
  end
end

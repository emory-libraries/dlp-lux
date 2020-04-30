# frozen_string_literal: true

class MetadataPresenter
  attr_reader :document, :config

  def initialize(document:)
    @document = document
    @config = YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'metadata.yml')))
  end

  def terms(section)
    @config = @config.symbolize_keys
    @section_terms = @config[section].symbolize_keys
    @document.slice(*@section_terms.keys)
  end
end

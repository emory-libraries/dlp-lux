# frozen_string_literal: true

class FindThisItemPresenter
  attr_reader :document, :config

  def initialize(document:, solr_document:)
    @document = document
    @config = YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'find_this_item.yml')))
    @solr_document = solr_document
  end

  def terms
    @config = @config.symbolize_keys
    @document.slice(*@config.keys)
  end

  def purl
    "https://digital.library.emory.edu/purl/#{@solr_document[:id]}"
  end
end

# frozen_string_literal: true

class MetadataPresenter
  attr_reader :document, :config

  def initialize(document:)
    @document = document
    @config = YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'metadata.yml')))
  end

  def terms
    @config = @config.symbolize_keys
  end

  def about_this_collection
    terms
    @about_collection = @config[:about_this_collection].symbolize_keys
    @document.slice(*@about_collection.keys)
  end

  def view_items_in_this_collection
    terms
    @view_items = @config[:view_items_in_this_collection].symbolize_keys
    @document.slice(*@view_items.keys)
  end
  def is_part_of
    terms
    @is_part_of = @config[:is_part_of].symbolize_keys
    @document.slice(*@is_part_of.keys)
  end
end

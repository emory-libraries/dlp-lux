# frozen_string_literal: true

class PublicationDetailsPresenter
  attr_reader :document, :config

  def initialize(document:)
    @document = document
    @config = YAML.safe_load(File.open(Rails.root.join('config', 'metadata', 'publication_details.yml')))
  end

  def terms
    @config = @config.keys
    @document.to_a.select { |field| @config.include? field.first }.to_enum
  end
end

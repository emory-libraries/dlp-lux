# frozen_string_literal: true

module Lux
  class ShowPdfViewerComponent < Blacklight::Component
    attr_reader :doc_id, :base_curate_url

    def initialize(doc_id:)
      @doc_id = doc_id
      @base_curate_url = ENV['THUMBNAIL_URL'] || ''
    end
  end
end

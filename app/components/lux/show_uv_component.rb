# frozen_string_literal: true

module Lux
  class ShowUvComponent < Blacklight::Component
    attr_reader :doc_id, :request_base_url, :iiif_url

    def initialize(doc_id:, request_base_url:)
      @doc_id = doc_id
      @request_base_url = request_base_url
      @iiif_url = Rails.application.config.iiif_url
    end
  end
end

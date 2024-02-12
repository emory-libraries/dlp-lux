# frozen_string_literal: true

module Lux
  class ShowDocumentComponent < Blacklight::Component
    attr_reader :document, :request_base_url

    renders_one :all_metadata, (lambda do
      ::Lux::ShowAllMetadataComponent.new(document: @document)
    end)

    def initialize(document:, request_base_url:)
      @document = document
      @request_base_url = request_base_url
      @thumbnail_url = ENV['THUMBNAIL_URL'] || ''
    end

    def show_nothing_tester
      @document["child_works_for_lux_tesim"] || (
        @document["has_model_ssim"] == ["Collection"] && @document["banner_path_ss"].nil?
      )
    end

    def show_banner_tester
      @document["has_model_ssim"] == ["Collection"] && @document["banner_path_ss"].present?
    end

    def banner_source
      @thumbnail_url + @document["banner_path_ss"]
    end

    def before_render
      set_slot(:all_metadata, nil)
    end
  end
end

# frozen_string_literal: true

module Lux
  class StaticContentComponent < Blacklight::Component
    attr_reader :header_class, :header_text, :body_class, :body_text

    def initialize(header_class:, header_text:, body_class:, body_text:)
      @header_class = ['static-blurb-header', header_class].join(' ')
      @header_text = header_text
      @body_class = ['static-blurb-body', body_class].join(' ')
      @body_text = sanitize(body_text)
    end
  end
end

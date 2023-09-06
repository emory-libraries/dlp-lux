# frozen_string_literal: true

module Lux
  class StaticHeadingComponent < Blacklight::Component
    attr_reader :title, :subheading

    def initialize(title:, subheading:)
      @title = title
      @subheading = subheading
    end
  end
end

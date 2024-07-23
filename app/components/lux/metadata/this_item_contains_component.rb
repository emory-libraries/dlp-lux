# frozen_string_literal: true

module Lux
  module Metadata
    class ThisItemContainsComponent < Blacklight::Component
      attr_reader :child_works, :thumbnail_url

      def initialize(document:)
        @document = document
      end

      def before_render
        @child_works = ::ThisItemContainsPresenter.new(document: @document).children
        @thumbnail_url = ENV['THUMBNAIL_URL'] || ''
      end
    end
  end
end

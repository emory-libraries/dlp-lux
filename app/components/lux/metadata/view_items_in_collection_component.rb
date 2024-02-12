# frozen_string_literal: true

module Lux
  module Metadata
    class ViewItemsInCollectionComponent < Blacklight::Component
      attr_reader :formatted_title

      def initialize(document:)
        @document = document
      end

      def before_render
        @formatted_title = CGI.escape(@document[:title_tesim]&.first)
      end
    end
  end
end

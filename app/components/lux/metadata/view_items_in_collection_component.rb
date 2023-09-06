# frozen_string_literal: true

module Lux
  module Metadata
    class ViewItemsInCollectionComponent < Blacklight::Component
      attr_reader :formatted_title

      def initialize(document:)
        @formatted_title = CGI.escape(document[:title_tesim]&.first)
      end
    end
  end
end

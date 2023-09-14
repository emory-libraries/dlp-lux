# frozen_string_literal: true

module Lux
  module Metadata
    class ThirdColumnComponent < Blacklight::Component
      attr_reader :document

      renders_one :access_and_copyright, (lambda do
        ::Lux::Metadata::AccessAndCopyrightComponent.new(document: @document)
      end)

      def initialize(document:)
        @document = document
      end

      def before_render
        set_slot(:access_and_copyright, nil)
      end
    end
  end
end

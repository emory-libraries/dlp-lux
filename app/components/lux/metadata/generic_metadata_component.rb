# frozen_string_literal: true

module Lux
  module Metadata
    class GenericMetadataComponent < Blacklight::Component
      attr_reader :document, :presenter_container_class, :title, :add_class_dt,
        :add_class_dd, :document_presenter. :fields
      def initialize(
        document:,
        presenter_klass:,
        presenter_container_class:,
        title:,
        add_class_dt:,
        add_class_dd:
      )
        @document = document
        @presenter_container_class = presenter_container_class
        @title = title
        @add_class_dt = add_class_dt
        @add_class_dd = add_class_dd
        @document_presenter = helpers.document_presenter(@document)
        @fields = presenter_klass.new(
          document: @document_presenter.fields_to_render
        ).terms
      end
    end
  end
end

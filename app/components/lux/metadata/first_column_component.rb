# frozen_string_literal: true

module Lux
  module Metadata
    class FirstColumnComponent < Blacklight::Component
      attr_reader :document
      renders_one :is_part_of, lambda do
        ::Lux::Metadata::IsPartOfComponent.new(document: @document)
      end
      renders_one :find_this_item, lambda do
        ::Lux::Metadata::FindThisItemComponent.new(document: @document)
      end
      renders_one :related_material, lambda do
        ::Lux::Metadata::GenericMetadataComponent.new(
          document: @document,
          presenter_klass: ::RelatedMaterialPresenter,
          presenter_container_class: 'related-material',
          title: 'Related Material',
          add_class_dt: 'col-md-12',
          add_class_dd: 'col-md-12'
        )
      end

      def initialize(document:)
        @document = document
      end

      def this_is_collection
        @document["has_model_ssim"]&.first == "Collection"
      end
    end
  end
end

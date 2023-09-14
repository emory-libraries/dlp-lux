# frozen_string_literal: true

module Lux
  module Metadata
    class MobileComponent < Blacklight::Component
      attr_reader :document
      renders_one :is_part_of, (lambda do
        ::Lux::Metadata::IsPartOfComponent.new(document: @document)
      end)
      renders_one :subject_keywords, (lambda do
        ::Lux::Metadata::GenericMetadataComponent.new(
          document: @document,
          presenter_klass: ::SubjectsKeywordsPresenter,
          presenter_container_class: 'subjects-keywords',
          title: 'Subjects / Keywords',
          add_class_dt: 'col-md-5',
          add_class_dd: 'col-md-7'
        )
      end)
      renders_one :find_this_item, (lambda do
        ::Lux::Metadata::FindThisItemComponent.new(document: @document)
      end)
      renders_one :access_and_copyright, (lambda do
        ::Lux::Metadata::AccessAndCopyrightComponent.new(document: @document)
      end)

      def initialize(document:)
        @document = document
      end

      def this_is_collection
        @document["has_model_ssim"]&.first == "Collection"
      end

      def this_is_work
        @document["has_model_ssim"]&.first == "CurateGenericWork"
      end

      def before_render
        set_slot(:is_part_of, nil)
        set_slot(:subject_keywords, nil)
        set_slot(:find_this_item, nil)
        set_slot(:access_and_copyright, nil)
      end
    end
  end
end

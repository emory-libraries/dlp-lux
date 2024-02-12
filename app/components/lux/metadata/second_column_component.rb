# frozen_string_literal: true

module Lux
  module Metadata
    class SecondColumnComponent < Blacklight::Component
      attr_reader :document
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
      renders_one :publication_details, (lambda do
        ::Lux::Metadata::GenericMetadataComponent.new(
          document: @document,
          presenter_klass: ::PublicationDetailsPresenter,
          presenter_container_class: 'publication-details',
          title: 'Publication Details',
          add_class_dt: 'col-md-5',
          add_class_dd: 'col-md-7'
        )
      end)
      renders_one :additional_details, (lambda do
        ::Lux::Metadata::GenericMetadataComponent.new(
          document: @document,
          presenter_klass: ::AdditionalDetailsPresenter,
          presenter_container_class: 'additional-details',
          title: 'Additional Details',
          add_class_dt: 'col-md-5',
          add_class_dd: 'col-md-7'
        )
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
        set_slot(:subject_keywords, nil)
        set_slot(:publication_details, nil)
        set_slot(:additional_details, nil)
      end
    end
  end
end

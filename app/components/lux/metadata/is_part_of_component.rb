# frozen_string_literal: true

module Lux
  module Metadata
    class IsPartOfComponent < Blacklight::Component
      attr_reader :fields, :source_collection_title, :title, :holding_repository,
        :human_readable_content_type, :link, :link_title, :col_link, :col_title

      def initialize(document:)
        @document = document
      end

      def collection_member_present
        @document['member_of_collection_ids_ssim'].present?
      end

      def parent_work_present
        @document['parent_work_for_lux_tesim'].present?
      end

      def before_render
        pull_variables_from_document
        document_presenter = helpers.document_presenter(@document)
        @fields = ::MetadataPresenter.new(
          document: document_presenter.fields_to_render
        ).terms(:is_part_of)

        if @source_collection_id.present? && @member_of_collection_id != @source_collection_id
          @col_link = @source_collection_id
          @col_title = @document.source_collection_title
        else
          @col_link = @member_of_collection_id
          @col_title = @member_of_collection
        end
      end

      def pull_variables_from_document
        @source_collection_title = @document['source_collection_title_ssim']&.first
        @title = @document['title_tesim'].first
        @holding_repository = @document['holding_repository_tesim']&.first
        @human_readable_content_type = @document['human_readable_content_type_ssim']&.first
        @member_of_collection_id = @document['member_of_collection_ids_ssim']&.first
        @source_collection_id = @document['source_collection_id_tesim']&.first
        @member_of_collection = @document["member_of_collections_ssim"]&.first
        @link, @link_title = @document['parent_work_for_lux_tesim']&.first&.split(', ')
      end
    end
  end
end

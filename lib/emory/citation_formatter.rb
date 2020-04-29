# frozen_string_literal: true
require 'citeproc'
require 'csl/styles'
require './lib/emory/citation_string_processor'

module Emory
  class CitationFormatter
    include CitationStringProcessor
    attr_accessor :obj, :default_citations

    def initialize(obj)
      @obj = obj
      @default_citations = {
        "apa": apa_default_citation,
        "chicago-fullnote-bibliography": chicago_default_citation,
        "modern-language-association": mla_default_citation
      }
    end

    def citation_for(style)
      sanitized_citation(CiteProc::Processor.new(style: style, format: 'html').import(item).render(:bibliography, id: :item).first)
    rescue CiteProc::Error, TypeError, ArgumentError
      @default_citations[style.to_sym]
    end

    private

      def item
        CiteProc::Item.new(key_value_chunk_1.merge(key_value_chunk_2).merge(key_value_chunk_3))
      end

      def mla_url_test
        [
          obj[:holding_repository_tesim],
          obj[:edition_tesim],
          obj[:publisher_tesim],
          obj[:date_issued_tesim]
        ].any?(&:present?)
      end

      def abnormal_chars?
        obj[:creator_tesim]&.any? { |a| a.match(/[^\p{L}\s]+/) }
      end

      def key_value_chunk_1
        {
          id: :item,
          abstract: obj[:abstract_tesim]&.join(', '),
          archive_location: obj[:sublocation_tesim]&.join(', '),
          author: obj[:creator_tesim]&.join(', '),
          "call-number": obj[:local_call_number_tesim]&.join(', '),
          edition: obj[:edition_tesim]&.join(', '),
          institution: obj[:institution_tesim]&.join(', ')
        }
      end

      def key_value_chunk_2
        {
          archive: obj[:holding_repository_tesim]&.join(', '),
          publisher: obj[:publisher_tesim]&.join(', '),
          title: obj[:title_tesim]&.join(', '),
          "collection-title": obj[:member_of_collections_ssim]&.join(', '),
          type: [obj[:human_readable_content_type_ssim]&.first&.downcase]&.join(', '),
          url: url,
          issued: (obj[:date_issued_tesim] || obj[:year_issued_isim] || obj[:year_created_isim] || [0])&.first&.to_i
        }
      end

      def key_value_chunk_3
        {
          dimensions: obj[:extent_tesim]&.join(', '),
          event: obj[:conference_name_tesim]&.join(', '),
          genre: obj[:content_genres_tesim]&.join(', '),
          ISBN: obj[:isbn_tesim]&.join(', '),
          ISSN: obj[:issn_tesim]&.join(', '),
          keyword: obj[:keywords_tesim]&.join(', '),
          "publisher-place": obj[:place_of_production_tesim]&.join(', ')
        }
      end
  end
end

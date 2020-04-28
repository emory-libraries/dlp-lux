# frozen_string_literal: true
require 'citeproc'

module Emory
  class CitationFormatter
    attr_accessor :obj, :default_citations

    def initialize(obj)
      @obj = obj
      @default_citations = { "apa": apa_default, "chicago-fullnote-bibliography": chicago_default, "modern-language-association": mla_default }
    end

    def citation_for(style)
      sanitized_citation(CiteProc::Processor.new(style: style, format: 'html').import(item).render(:bibliography, id: :item).first)
    rescue CiteProc::Error, TypeError, ArgumentError
      @default_citations[style.to_sym]
    end

    private

      def item
        CiteProc::Item.new(key_val_chunk_1.merge(key_val_chunk_2).merge(key_val_chunk_3))
      end

      def url
        return unless obj[:id]
        "https://digital.library.emory.edu/purl/#{obj[:id]}"
      end

      def proc_mid_com(field)
        "#{field&.first}, " if field.present?
      end

      def proc_mid_per(field)
        "#{field&.first}. " if field.present?
      end

      def mla_url_test
        [obj[:holding_repository_tesim], obj[:edition_tesim], obj[:publisher_tesim], obj[:date_issued_tesim]].any?(&:present?)
      end

      def  apa_edition
        ", #{obj[:edition_tesim].first}" if obj[:edition_tesim].present?
      end

      def sanitized_citation(citation)
        if !citation.include?(url) && citation.last != "."
          citation << ". #{url}."
        elsif !citation.include?(url) && citation.last == "."
          citation << " #{url}."
        else
          citation
        end
      end

      def auth_no_per
        return obj[:creator_tesim].map { |a| a.first(a.size - 1) } if obj[:creator_tesim]&.any? { |a| a&.split('')&.last == '.' }
        obj[:creator_tesim]
      end

      def sanitized_apa_auth
        return apa_creator_name unless abnormal_chars? || obj[:creator_tesim].blank?
        "#{auth_no_per&.join(', & ')}. " unless obj[:creator_tesim].blank?
      end

      def sanitized_mla_auth
        return mla_creator_name unless abnormal_chars? || obj[:creator_tesim].blank?
        "#{auth_no_per&.join(', ')}. " unless obj[:creator_tesim].blank?
      end

      def sanitized_chic_auth
        "#{auth_no_per&.join(', ')}, " unless auth_no_per.nil?
      end

      def apa_default
        [
          sanitized_apa_auth, ("(#{obj[:date_issued_tesim]&.first})" unless obj[:date_issued_tesim].nil?),
          ("[#{obj[:title_tesim]&.first}#{apa_edition}]. " unless obj[:title_tesim].nil?),
          proc_mid_com(obj[:member_of_collections_ssim]), proc_mid_per(obj[:holding_repository_tesim]), url, "."
        ].join('')
      end

      def chicago_default
        [
          sanitized_chic_auth, proc_mid_com(obj[:title_tesim]),
          proc_mid_com(obj[:date_issued_tesim]), proc_mid_com(obj[:member_of_collections_ssim]),
          proc_mid_per(obj[:holding_repository_tesim]), url, "."
        ].join('')
      end

      def mla_default
        [
          sanitized_mla_auth, proc_mid_per(obj[:title_tesim]), proc_mid_per(obj[:date_issued_tesim]),
          proc_mid_per(obj[:member_of_collections_ssim]), proc_mid_per(obj[:holding_repository_tesim]), url, "."
        ].join('')
      end

      def abnormal_chars?
        obj[:creator_tesim]&.any? { |a| a.match(/[^A-Za-z\s]+/) }
      end

      def apa_creator_name
        "#{obj[:creator_tesim].map { |f| f.split(' ').last + ', ' + f.split(' ').first(f.split.size - 1)&.map(&:first)&.join('. ') }&.join(', & ')}. "
      end

      def mla_creator_name
        "#{obj[:creator_tesim].map { |f| f.split(' ').last + ', ' + f.split(' ').first(f.split.size - 1).join(' ') }&.join(', ')}. "
      end

      def key_val_chunk_1
        { id: :item, abstract: obj[:abstract_tesim]&.join(', '), archive_location: obj[:sublocation_tesim]&.join(', '), author: obj[:creator_tesim]&.join(', '),
          "call-number": obj[:local_call_number_tesim]&.join(', '), edition: obj[:edition_tesim]&.join(', '), institution: obj[:institution_tesim]&.join(', ') }
      end

      def key_val_chunk_2
        { archive: obj[:holding_repository_tesim]&.join(', '), publisher: obj[:publisher_tesim]&.join(', '), title: obj[:title_tesim]&.join(', '),
          "collection-title": obj[:member_of_collections_ssim]&.join(', '), type: [obj[:human_readable_content_type_ssim]&.first&.downcase]&.join(', '),
          url: url, issued: (obj[:date_issued_tesim] || obj[:year_issued_isim] || obj[:year_created_isim] || [0])&.first&.to_i }
      end

      def key_val_chunk_3
        { dimensions: obj[:extent_tesim]&.join(', '), event: obj[:conference_name_tesim]&.join(', '), genre: obj[:content_genres_tesim]&.join(', '),
          ISBN: obj[:isbn_tesim]&.join(', '), ISSN: obj[:issn_tesim]&.join(', '), keyword: obj[:keywords_tesim]&.join(', '),
          "publisher-place": obj[:place_of_production_tesim]&.join(', ') }
      end
  end
end

# frozen_string_literal: true
require 'bibtex'
require 'citeproc'
require 'csl/styles'

module Blacklight::Citeproc
  class BadConfigError < StandardError
  end

  class CitationController < ApplicationController
    include Blacklight::Searchable

    def initialize
      @processors = []
      @citations = []

      throw BadConfigError, 'Catalog controller needs a config.citeproc section' unless blacklight_config.citeproc
      @config = blacklight_config.citeproc
      @config[:styles].each do |style|
        @processors << ::CiteProc::Processor.new(format: 'html', style: style)
      end
    end

    def print_single
      _, document = get_docs
      bibtex = ::BibTeX::Bibliography.new
      fill_bibtex(bibtex, document)

      @processors.each do |processor|
        processor.import bibtex.to_citeproc
        citation = processor.render(:bibliography, id: params[:id]).first.tr('{}', '')
        citation_arr(citation, processor, params[:id])
      end
      urlize_id
      render layout: false
    end

    def print_bookmarks
      ids = bookmark_ids
      _, documents = get_docs(ids)
      bibtex = ::BibTeX::Bibliography.new
      documents.each { |d| fill_bibtex(bibtex, d) }
      @citations = []

      @processors.each do |processor|
        processor.import bibtex.to_citeproc
        bibliographies = ids.map { |id| [processor.render(:bibliography, id: id), id].flatten }
        bibliographies.each { |bib, id| citation_arr(bib, processor, id) }
      end
      @citations.sort_by! { |c| c[:citation] }
      urlize_id
      render :print_multiple, layout: false
    end

    private

      def bookmark_ids
        current_user.bookmarks&.map { |b| b.document_id.to_s }
      end

      def get_docs(ids = params[:id])
        search_service.fetch(ids)
      end

      def fill_bibtex(bibtex, document)
        bibtex << document.export_as(:bibtex)
      end

      def urlize_id
        @citations.each do |c|
          c[:citation].gsub!(/#{c[:id]}/, "https://digital.library.emory.edu/purl/#{c[:id]}")
        end
      end

      def citation_arr(bib, processor, id)
        @citations << { citation: bib, label: processor.options[:style], id: id }
      end
  end
end

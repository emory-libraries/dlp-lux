module Emory
  class CitationFormatter
    attr_accessor :object

    def initialize(object, style)
      @object = object
      @style = style
    end

    def citation
      CiteProc::Processor
        .new(style: @style, format: 'html')
        .import(item)
        .render(:bibliography, id: :item)
        .first
    rescue CiteProc::Error, TypeError, ArgumentError
      "#{@object['creator_tesim']&.join(', ')}. (#{@object['date_issued_tesim']&.first}). <i>#{@object['title_tesim']&.first}</i>. #{@object['publisher_tesim']&.first}."
    end

    def item
      CiteProc::Item.new(
        author: object['creator_tesim'],
        edition: object['edition_tesim'],
        institution: object['institution_tesim'],
        organization: object['holding_repository_tesim'],
        publisher: object['publisher_tesim'],
        series: [object['member_of_collections_ssim'], object['series_title_tesim']],
        title: object['title_tesim'],
        type: object['content_genres_tesim'],
        url: object['id'],
        year: object['date_issued_tesim']
      )
    end

    def doi
      object.identifier.first
    end

    def url
      return unless object['id']
      "https://digital.library.emory.edu/purl/#{object.id}"
    end
  end
end

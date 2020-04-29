# frozen_string_literal: true

module CitationStringProcessor
  def url
    "https://digital.library.emory.edu/purl/#{obj[:id]}" if obj[:id]
  end

  def append_string_with_comma(field)
    "#{field&.first}, " if field.present?
  end

  def append_string_with_period(field)
    "#{field&.first}. " if field.present?
  end

  def apa_edition
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

  def author_name_no_period
    return obj[:creator_tesim].map { |a| a.first(a.size - 1) } if obj[:creator_tesim]&.any? { |a| a&.split('')&.last == '.' }
    obj[:creator_tesim]
  end

  def formatted_apa_author
    return joined_apa_author_names unless abnormal_chars? || obj[:creator_tesim].blank?
    "#{author_name_no_period&.join(', & ')}. " unless obj[:creator_tesim].blank?
  end

  def formatted_mla_author
    return joined_mla_author_names unless abnormal_chars? || obj[:creator_tesim].blank?
    "#{author_name_no_period&.join(', ')}. " unless obj[:creator_tesim].blank?
  end

  def formatted_chicago_author
    "#{author_name_no_period&.join(', ')}, " unless author_name_no_period.nil?
  end

  def apa_default_citation
    [
      formatted_apa_author,
      ("(#{obj[:date_issued_tesim]&.first})" unless obj[:date_issued_tesim].nil?),
      ("[#{obj[:title_tesim]&.first}#{apa_edition}]. " unless obj[:title_tesim].nil?),
      append_string_with_comma(obj[:member_of_collections_ssim]),
      append_string_with_period(obj[:holding_repository_tesim]),
      url,
      "."
    ].join('')
  end

  def chicago_default_citation
    [
      formatted_chicago_author,
      append_string_with_comma(obj[:title_tesim]),
      append_string_with_comma(obj[:date_issued_tesim]),
      append_string_with_comma(obj[:member_of_collections_ssim]),
      append_string_with_period(obj[:holding_repository_tesim]),
      url,
      "."
    ].join('')
  end

  def mla_default_citation
    [
      formatted_mla_author,
      append_string_with_period(obj[:title_tesim]),
      append_string_with_period(obj[:date_issued_tesim]),
      append_string_with_period(obj[:member_of_collections_ssim]),
      append_string_with_period(obj[:holding_repository_tesim]),
      url,
      "."
    ].join('')
  end

  def joined_apa_author_names
    "#{obj[:creator_tesim].map { |f| f.split(' ').last + ', ' + f.split(' ').first(f.split.size - 1)&.map(&:first)&.join('. ') }&.join(', & ')}. "
  end

  def joined_mla_author_names
    "#{obj[:creator_tesim].map { |f| f.split(' ').last + ', ' + f.split(' ').first(f.split.size - 1).join(' ') }&.join(', ')}. "
  end
end

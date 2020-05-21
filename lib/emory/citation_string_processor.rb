# frozen_string_literal: true

module CitationStringProcessor
  include AdditionalCatalogHelper

  def url(obj)
    purl(obj[:id]) if obj.present? && obj[:id].present?
  end

  def append_string_with_comma(field)
    "#{field&.first}, " if field.any?(&:present?)
  end

  def append_string_with_period(field)
    "#{field&.first}. " if field.any?(&:present?)
  end

  def apa_edition(obj)
    ", #{obj[:edition_tesim].first}" if obj.present? && obj[:edition_tesim].present?
  end

  def sanitized_citation(citation, obj)
    if !citation.include?(url(obj)) && citation.last != "."
      "#{citation}. #{url(obj)}."
    elsif !citation.include?(url(obj)) && citation.last == "."
      "#{citation} #{url(obj)}."
    else
      citation
    end
  end

  def author_name_no_period(obj)
    return obj[:creator_tesim].map { |a| a.first(a.size - 1) } if obj[:creator_tesim]&.any? { |a| a&.split('')&.last == '.' }
    obj[:creator_tesim]
  end

  def formatted_apa_author
    return joined_apa_author_names unless abnormal_chars? || obj[:creator_tesim].blank?
    "#{author_name_no_period(obj)&.join(', & ')}. " unless obj[:creator_tesim].blank?
  end

  def formatted_mla_author
    return joined_mla_author_names unless abnormal_chars? || obj[:creator_tesim].blank?
    "#{author_name_no_period(obj)&.join(', ')}. " unless obj[:creator_tesim].blank?
  end

  def formatted_chicago_author
    "#{author_name_no_period(obj)&.join(', ')}, " unless author_name_no_period(obj).nil?
  end

  def apa_default_citation
    [
      formatted_apa_author,
      apa_date_selector,
      ("[#{obj[:title_tesim]&.first}#{apa_edition(obj)}]. " unless obj[:title_tesim].nil?),
      append_string_with_comma(obj[:member_of_collections_ssim]),
      append_string_with_period(obj[:holding_repository_tesim]), url(obj), "."
    ].join('')
  end

  def chicago_default_citation
    [
      formatted_chicago_author, append_string_with_comma(obj[:title_tesim]),
      append_string_with_comma(obj[:date_issued_tesim] || obj[:human_readable_date_created_tesim]),
      append_string_with_comma(obj[:member_of_collections_ssim]),
      append_string_with_period(obj[:holding_repository_tesim]), url(obj), "."
    ].join('')
  end

  def mla_default_citation
    [
      formatted_mla_author,
      append_string_with_period(obj[:title_tesim]),
      append_string_with_period(obj[:date_issued_tesim] || obj[:human_readable_date_created_tesim]),
      append_string_with_period(obj[:member_of_collections_ssim]),
      append_string_with_period(obj[:holding_repository_tesim]),
      url(obj),
      "."
    ].join('')
  end

  def joined_apa_author_names
    "#{obj[:creator_tesim].map { |f| f.split(' ').last + ', ' + f.split(' ').first(f.split.size - 1)&.map(&:first)&.join('. ') }&.join(', & ')}. "
  end

  def joined_mla_author_names
    "#{obj[:creator_tesim].map { |f| f.split(' ').last + ', ' + f.split(' ').first(f.split.size - 1).join(' ') }&.join(', ')}. "
  end

  def apa_date_selector
    if obj[:date_issued_tesim].present?
      "(#{obj[:date_issued_tesim]&.first})"
    elsif obj[:date_issued_tesim].nil? && obj[:human_readable_date_created_tesim].present?
      "(#{obj[:human_readable_date_created_tesim]&.first})"
    end
  end
end

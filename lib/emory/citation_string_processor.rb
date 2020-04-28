# frozen_string_literal: true

module CitationStringProcessor
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

  def apa_creator_name
    "#{obj[:creator_tesim].map { |f| f.split(' ').last + ', ' + f.split(' ').first(f.split.size - 1)&.map(&:first)&.join('. ') }&.join(', & ')}. "
  end

  def mla_creator_name
    "#{obj[:creator_tesim].map { |f| f.split(' ').last + ', ' + f.split(' ').first(f.split.size - 1).join(' ') }&.join(', ')}. "
  end
end

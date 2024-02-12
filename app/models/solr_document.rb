# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  # The following shows how to setup this blacklight document to display marc documents
  extension_parameters[:marc_source_field] = :marc_ss
  extension_parameters[:marc_format_type] = :marcxml
  use_extension(Blacklight::Marc::DocumentExtension) do |document|
    document.key?(SolrDocument.extension_parameters[:marc_source_field])
  end

  field_semantics.merge!(
    title: "title_ssm",
    author: "author_ssm",
    language: "language_ssim",
    format: "format"
  )

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # string display methods
  def standard_title
    self[:title_tesim]&.first
  end

  def title_split
    standard_title&.split(' ')
  end

  def title_first3
    title_split&.first(3)
  end

  def title_abbr
    title_first3.join(' ') + '...' if title_split.size > 3
  end

  def standard_link
    "/catalog/#{self['id']}"
  end

  def collection_link
    "/catalog/#{self['member_of_collection_ids_ssim']&.first}"
  end

  def source_collection_link
    "/catalog/#{self['source_collection_id_tesim']&.first}"
  end

  def parent_work_link
    "/catalog/#{self['parent_work_for_lux_tesim']&.first&.split(', ')&.first}"
  end

  # document typing tests
  def parent?
    self['parent_work_for_lux_tesim'].present?
  end

  def related_collection?
    self['member_of_collection_ids_ssim'].present?
  end

  def collection?
    self['has_model_ssim']&.first == 'Collection'
  end

  def work?
    self['has_model_ssim']&.first == 'CurateGenericWork'
  end

  def source_collection_title
    self['source_collection_title_ssim']&.first
  end

  # document typing test groups
  def parent_collection
    collection? && related_collection?
  end

  def no_parent_work_w_collection
    work? && !parent? && related_collection?
  end

  def parent_work_w_collection
    work? && parent? && related_collection?
  end

  def parent_work_no_collection
    work? && parent? && !related_collection?
  end

  # breadcrumb link hashes
  def item_breadcrumb
    { curr_page: true, abbr: title_abbr, link: standard_link, title: standard_title }
  end

  def back_collection_breadcrumb
    { curr_page: false, abbr: nil, link: col_link, title: I18n.t('b_t_c') }
  end

  def back_parent_breadcrumb
    { curr_page: false, abbr: nil, link: parent_work_link, title: I18n.t('b_t_p_o') }
  end

  def back_parent_coll_breadcrumb
    { curr_page: false, abbr: nil, link: collection_link, title: I18n.t('b_t_p_o') }
  end

  private

  def col_link
    source_collection_id = self['source_collection_id_tesim']&.first
    return source_collection_link unless source_collection_id.nil? || self['member_of_collection_ids_ssim']&.first == source_collection_id
    collection_link
  end
end

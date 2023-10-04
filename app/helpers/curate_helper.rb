# frozen_string_literal: true

module CurateHelper
  # @!group Document helpers
  ##
  # Render the index field label for a document
  #
  # Translations for index field labels should go under blacklight.search.fields
  # They are picked up from there by a value "%{label}" in blacklight.search.index.label
  #
  # @deprecated
  # @overload render_index_field_label(options)
  #   Use the default, document-agnostic configuration
  #   @param [Hash] opts
  #   @option opts [String] :field
  # @overload render_index_field_label(document, options)
  #   Allow an extention point where information in the document
  #   may drive the value of the field
  #   @param [SolrDocument] doc
  #   @param [Hash] opts
  #   @option opts [String] :field
  # @return [String]
  def render_index_field_label(*args)
    options = args.extract_options!
    document = args.first

    field = options[:field]

    # BlacklightHelper v7.33.1 Override - Do not display any label for holding_repository_tesim
    return nil if field == "holding_repository_tesim"

    label = Deprecation.silence(Blacklight::ConfigurationHelperBehavior) do
      options[:label] || index_field_label(document, field)
    end
    html_escape t(:"blacklight.search.index.#{document_index_view_type}.label", default: :'blacklight.search.index.label', label:)
  end
  deprecation_deprecate render_index_field_label: 'Use Blacklight::MetadataFieldComponent instead'
end

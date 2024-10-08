# frozen_string_literal: true
# Blacklight v7.33.1 Override - introduces Lux specific logic with #lux_thumbnail_url,
#   #thumbnail_image_url, and #thumbnail_value.

module Blacklight
  class ThumbnailPresenter
    attr_reader :document, :view_context, :view_config

    # @param [SolrDocument] document
    # @param [ActionView::Base] view_context scope for linking and generating urls
    #                                        as well as for invoking "thumbnail_method"
    # @param [Blacklight::Configuration::ViewConfig] view_config
    def initialize(document, view_context, view_config)
      @document = document
      @view_context = view_context
      @view_config = view_config
    end

    def render(image_options = {})
      thumbnail_value(image_options)
    end

    ##
    # Does the document have a thumbnail to render?
    #
    # @return [Boolean]
    def exists?
      thumbnail_method.present? ||
        (thumbnail_field && thumbnail_value_from_document.present?) ||
        default_thumbnail.present?
    end

    ##
    # Render the thumbnail, if available, for a document and
    # link it to the document record.
    #
    # @param [Hash] image_options to pass to the image tag
    # @param [Hash] url_options to pass to #link_to_document
    # @return [String]
    def thumbnail_tag(image_options = {}, url_options = {})
      value = thumbnail_value(image_options)
      return value if value.nil? || url_options[:suppress_link]

      view_context.link_to_document document, value, url_options
    end

    private

    delegate :thumbnail_field, :thumbnail_method, :default_thumbnail, to: :view_config

    # @param [Hash] image_options to pass to the image tag
    def thumbnail_value(image_options)
      value = if thumbnail_field
                image_url = thumbnail_image_url
                image_options[:alt] = "Thumbnail image"
                image_options[:class] = "img-fluid"
                view_context.image_tag image_url, image_options if image_url.present?
              end

      value || default_thumbnail_value(image_options)
    end

    def thumbnail_image_url
      visibility = document["visibility_ssi"]
      case visibility
      when "open", "low_res"
        lux_thumbnail_url
      when "emory_low", "authenticated" # Authenticated is the same as Emory High Download
        return 'login-required.png' unless view_context&.current_user
        lux_thumbnail_url
      when "rose_high"
        return 'reading-room-only.png' unless view_context.current_ability.user_groups.include?('rose_high')
        lux_thumbnail_url
      end
    end

    def lux_thumbnail_url
      (ENV['THUMBNAIL_URL'] || '') + "/iiif/#{thumbnail_value_from_document}/thumbnail"
    end

    def default_thumbnail_value(image_options)
      return unless default_thumbnail

      case default_thumbnail
      when Symbol
        view_context.send(default_thumbnail, document, image_options)
      when Proc
        default_thumbnail.call(document, image_options)
      else
        view_context.image_tag default_thumbnail, image_options
      end
    end

    def thumbnail_value_from_document
      Array(thumbnail_field).lazy.map { |field| retrieve_values(field_config(field)).first }.reject(&:blank?).first
    end

    def retrieve_values(field_config)
      FieldRetriever.new(document, field_config, view_context).fetch
    end

    def field_config(field)
      return field if field.is_a? Blacklight::Configuration::Field

      Configuration::NullField.new(field)
    end
  end
end

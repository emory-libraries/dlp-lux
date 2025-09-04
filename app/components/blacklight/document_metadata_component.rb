# frozen_string_literal: true

module Blacklight
  class DocumentMetadataComponent < Blacklight::Component
    renders_many :fields, (lambda do |component: nil, **kwargs|
      (component || Lux::MetadataFieldComponent).new(**kwargs)
    end)
    with_collection_parameter :fields

    # rubocop:disable Metrics/ParameterLists
    # @param fields [Enumerable<Blacklight::FieldPresenter>] Document field presenters
    def initialize(fields: [], tag: 'dl', classes: nil, show: false, field_layout: nil, **component_args)
      @fields = fields
      @tag = tag
      @classes = classes
      @show = show
      @field_layout = field_layout
      @component_args = component_args
    end
    # rubocop:enable Metrics/ParameterLists

    def before_render
      return unless fields

      @fields.each do |field|
        with_field(component: field_component(field), field:, show: @show, layout: @field_layout)
      end
    end

    def render?
      fields.present?
    end

    def field_component(field)
      field&.component || Lux::MetadataFieldComponent
    end
  end
end

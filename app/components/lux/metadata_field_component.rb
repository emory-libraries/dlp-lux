# frozen_string_literal: true

class Lux::MetadataFieldComponent < Blacklight::MetadataFieldComponent
  # @param field [Blacklight::FieldPresenter]
  # @param layout [Blacklight::MetadataFieldLayoutComponent] alternate layout component to use
  # @param show [Boolean] are we showing only a single document (vs a list of search results); used for backwards-compatibility
  def initialize(field:, layout: nil, show: false)
    @field = field
    @layout = layout || Lux::MetadataFieldLayoutComponent
    @show = show
  end
end

# frozen_string_literal: true

# NOTE: This is a copy of Blacklight v7.33.1's Blacklight::MetadataFieldComponent.
#   It is necessary to bring Components that are called within an overridden component
#   into an application using Blacklight because they expect the Components being called
#   to be within the same directory. Tests will be copied as well.
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

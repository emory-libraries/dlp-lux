# frozen_string_literal: true
# Blacklight v7.33.1 Override - changes the label and value classes to what we expect.
#   There is no spec written for this component in Blacklight.

class Lux::MetadataFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
  # @param field [Blacklight::FieldPresenter]
  def initialize(field:, label_class: 'index-field-name', value_class: '')
    @field = field
    @key = @field.key.parameterize
    @label_class = label_class
    @value_class = value_class
  end
end

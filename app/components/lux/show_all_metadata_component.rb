# frozen_string_literal: true

module Lux
  class ShowAllMetadataComponent < Blacklight::Component
    renders_one :first_column, (lambda do
      ::Lux::Metadata::FirstColumnComponent.new(document: @document)
    end)
    renders_one :second_column, (lambda do
      ::Lux::Metadata::SecondColumnComponent.new(document: @document)
    end)
    renders_one :third_column, (lambda do
      ::Lux::Metadata::ThirdColumnComponent.new(document: @document)
    end)
    renders_one :mobile, (lambda do
      ::Lux::Metadata::MobileComponent.new(document: @document)
    end)

    def initialize(document:)
      @document = document
    end

    def before_render
      set_slot(:first_column, nil)
      set_slot(:second_column, nil)
      set_slot(:third_column, nil)
      set_slot(:mobile, nil)
    end
  end
end

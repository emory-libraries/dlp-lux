# frozen_string_literal: true
# Class modeling configuration options for the Universal Viewer
class UvConfiguration < ActiveSupport::HashWithIndifferentAccess
  # Provides the default values for the viewer
  # @return [Hash]
  def self.default_values
    {
      "modules" =>
      {
        "footerPanel" =>
        {
          "options" =>
          {
            "shareEnabled" => false,
            "downloadEnabled" => false
          }
        }
      }
    }
  end

  # Constructor
  # @param values [Hash] configuration options for the Universal Viewer
  # @see https://github.com/UniversalViewer/universalviewer/wiki/Configuration
  def initialize(values = {})
    build_values = self.class.default_values.deep_merge(values.with_indifferent_access)

    super(build_values)
  end
end

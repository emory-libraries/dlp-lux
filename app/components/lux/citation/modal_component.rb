# frozen_string_literal: true
# Blacklight v7.33.1 rewrite of app/components/blacklight/system/modal_component.rb

module Lux
  module Citation
    class ModalComponent < ViewComponent::Base
      include ::Blacklight::ContentAreasShim

      renders_one :body
      renders_one :footer
    end
  end
end

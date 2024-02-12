# frozen_string_literal: true

module Blacklight
  class SearchButtonComponent < ::ViewComponent::Base
    def initialize(text:, id:)
      @text = text
      @id = id
    end

    def call
      tag.button(class: 'btn btn-primary search-btn rounded-0', type: 'submit', id: @id) do
        tag.span(@text, class: "submit-search-text")
      end
    end
  end
end

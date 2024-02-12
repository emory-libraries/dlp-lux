# frozen_string_literal: true

module Lux
  class ExploreCollectionsComponent < Blacklight::Component
    attr_reader :collections

    def initialize
      @collections = ::ExploreCollectionsPresenter.new.collections
    end

    def explore_collections_path
      helpers.search_action_path('f[has_model_ssim][]' => 'Collection', 'f[visibility_ssi][]' => 'open')
    end
  end
end

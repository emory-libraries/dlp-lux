# frozen_string_literal: true

module Admin
  class ContentBlocksController < Admin::ApplicationController
    def valid_action?(name, resource = resource_class)
      %w[destroy].exclude?(name.to_s) && super
    end
  end
end

# frozen_string_literal: true

module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      raise CanCan::AccessDenied unless current_ability.admin?
    end
  end
end

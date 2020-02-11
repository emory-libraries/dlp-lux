# frozen_string_literal: true
class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout :determine_layout if respond_to? :layout

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied, with: :render_404

  def render_404
    render file: Rails.root.join('public', '404.html'), status: :not_found, layout: true
  end

  # GET /uv/config
  # Retrieve the UV configuration for a given resource
  def uv_config
    config = if user_signed_in?
               uv_config_liberal
             else
               default_config
             end

    respond_to do |format|
      format.json { render json: config }
    end
  end

  def resource_id_param
    params[:id]
  end

  # Construct a UV configuration with the default options (conservative)
  # @return [UvConfiguration]
  def default_config
    UvConfiguration.new
  end

  # Construct a UV configuration with downloads and share enabled
  # @return [UvConfiguration]
  def uv_config_liberal
    UvConfiguration.new(
      modules: {
        footerPanel: {
          options: {
            shareEnabled: true,
            downloadEnabled: true,
            fullscreenEnabled: true
          }
        }
      }
    )
  end
end

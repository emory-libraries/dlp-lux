# frozen_string_literal: true
class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include HttpAuthConcern

  layout :determine_layout if respond_to? :layout

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied, with: :render_404

  def render_404
    render file: Rails.root.join('public', '404.html'), status: :not_found, layout: true
  end

  # GET /uv/config
  # Retrieve the UV configuration for a given resource
  def uv_config
    v = visibility_lookup(resource_id_param)
    config = if v == "open"
               uv_config_liberal
             elsif v == "authenticated" && user_signed_in?
               uv_config_liberal
             elsif v == "emory_low" && user_signed_in?
               uv_config_liberal_low
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

  # Construct a UV configuration for emory_low visibility with downloads and share enabled,
  # and download dialogue options/content modifications
  # @return [UvConfiguration]
  def uv_config_liberal_low # rubocop:disable Metrics/MethodLength
    UvConfiguration.new(
      modules: {
        footerPanel: {
          options: {
            shareEnabled: true,
            downloadEnabled: true,
            fullscreenEnabled: true
          }
        },
        downloadDialogue: {
          options: {
            currentViewDisabledPercentage: 0, # set to an unreasonably low value so that Current View option is hidden
            confinedImageSize: 100_000 # set to an unreasonably high value so that Whole Image Low Res option is hidden
          },
          content: {
            wholeImageHighRes: "Whole Image 400px"
          }
        }
      }
    )
  end # rubocop:enable Metrics/MethodLength

  def visibility_lookup(resource_id)
    response = Blacklight.default_index.connection.get 'select', params: { q: "id:#{resource_id}" }
    response["response"]["docs"].first["visibility_ssi"]
  end

  private

    def current_ability
      @current_ability ||= Ability.new(current_user, user_ip)
    end

    def user_ip
      return request.headers["X-Forwarded-For"] if request.headers["X-Forwarded-For"]
      return request.headers["REMOTE_ADDR"] if request.headers["REMOTE_ADDR"]
    end
end

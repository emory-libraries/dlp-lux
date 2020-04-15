# frozen_string_literal: true
class StaticController < ApplicationController
  # Accesses static about page: /about
  def about
    render "static/about"
  end

  # Accesses static contact page: /contact
  def contact
    render "static/contact"
  end

  # Accesses static copyright and reuse page: /copyright-reuse
  def copyright_reuse
    render "static/copyright_reuse"
  end

  def not_found
    render status: 404
  end
end

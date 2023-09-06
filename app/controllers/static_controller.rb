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

  def not_found
    render status: :not_found
  end
end

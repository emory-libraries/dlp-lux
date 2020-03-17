# frozen_string_literal: true
class StaticController < ApplicationController
  # Accesses static about page: /about
  def contact
    render "static/contact"
  end
end

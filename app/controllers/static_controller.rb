# frozen_string_literal: true
class StaticController < ApplicationController
  # Accesses static about page: /about
  def about
    render "static/about"
  end
end

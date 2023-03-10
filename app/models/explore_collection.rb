# frozen_string_literal: true
class ExploreCollection < ApplicationRecord
  validates_presence_of :title, :banner_path, :collection_path, :description
end

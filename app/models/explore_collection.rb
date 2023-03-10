# frozen_string_literal: true
class ExploreCollection < ApplicationRecord
  validates :title, presence: true
  validates :banner_path, presence: true
  validates :collection_path, presence: true
  validates :description, presence: true
end

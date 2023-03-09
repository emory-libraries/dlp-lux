# frozen_string_literal: true
class ContentBlock < ApplicationRecord
  validates :reference, presence: true
  delegate :blank?, to: :value

  def self.homepage_banner
    ContentBlock.find_by(reference: 'homepage_banner') || ContentBlock.blank(reference: 'homepage_banner')
  end

  def self.blank(reference:)
    ContentBlock.new(reference: reference, value: '')
  end
end

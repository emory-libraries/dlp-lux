# frozen_string_literal: true

class ThisItemContainsPresenter
  attr_reader :document

  def initialize(document:)
    @document = document
  end

  def children
    return nil unless @document["child_works_for_lux_tesim"]
    @document["child_works_for_lux_tesim"].map do |w|
      parts = w.split(", ", 3)
      { id: parts[0], thumbnail_path: parts[1], title: parts[2] }
    end
  end
end

# frozen_string_literal: true

class ExploreCollectionsPresenter
  attr_reader :collections

  def initialize
    @collections = ExploreCollection.all.select(&:active?).sample(3)
  end
end

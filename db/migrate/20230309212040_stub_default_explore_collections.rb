require_relative '../concerns/default_explore_collections'

class StubDefaultExploreCollections < ActiveRecord::Migration[5.2]
  include ::DefaultExploreCollections

  def change
    stub_default_explore_collections
  end
end

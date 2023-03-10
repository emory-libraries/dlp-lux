class CreateExploreCollections < ActiveRecord::Migration[5.2]
  def up
    create_table :explore_collections, if_not_exists: true do |t|
      t.string :title
      t.string :banner_path
      t.string :collection_path
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end
  end

  def down
    drop_table :explore_collections, if_exists: true
  end
end

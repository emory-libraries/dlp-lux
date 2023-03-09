class CreateContentBlocks < ActiveRecord::Migration[5.2]
  def up
    create_table :content_blocks, if_not_exists: true do |t|
      t.string :reference
      t.string :value

      t.timestamps
    end
  end

  def down
    drop_table :content_blocks, if_exists: true
  end
end

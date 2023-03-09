class AddHomepageBannerContentBlock < ActiveRecord::Migration[5.2]
  def up
    ContentBlock.create(reference: 'homepage_banner', value: '')
  end

  def down
    ContentBlock.find_by(reference: 'homepage_banner').destroy
  end
end

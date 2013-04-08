class AddTitleToFeed < ActiveRecord::Migration
  def up
    add_column :feeds, :title, :string
    Feed.all.each do |f|
      f.send(:verify_url)
      f.save
    end
  end

  def down
    remove_column :feeds, :title
  end
end

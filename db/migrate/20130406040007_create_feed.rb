class CreateFeed < ActiveRecord::Migration
  def up
    create_table :feeds do |t|
      t.string :url
      t.integer :user_id
    end
  end

  def down
    drop_table :feeds
  end
end

class CreateFollowings < ActiveRecord::Migration
  def up
    create_table :followings do |t|
      t.integer :follower_id
      t.integer :following_id
    end

    add_index :followings, :follower_id
  end

  def down
    drop_table :followings
  end
end

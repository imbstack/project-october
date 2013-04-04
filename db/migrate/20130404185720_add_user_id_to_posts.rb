class AddUserIdToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :user_id, :integer
    add_index :posts, :user_id

    Post.update_all("user_id = #{User.first.id}") if User.first
  end

  def down
    remove_column :posts, :user_id
  end
end

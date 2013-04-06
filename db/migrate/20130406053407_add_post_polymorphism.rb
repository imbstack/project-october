class AddPostPolymorphism < ActiveRecord::Migration
  def up
    rename_column :posts, :user_id, :posted_by_id
    add_column :posts, :posted_by_type, :string, :default => 'User'
  end

  def down
    Post.where('posted_by_type <> ?', 'User').delete_all
    remove_column :posts, :posted_by_type
    rename_column :posts, :posted_by_id, :user_id
  end
end

class RenamePostedBy < ActiveRecord::Migration
  def up
    rename_column :posts, :posted_by_id, :poster_id
  end

  def down
    rename_column :posts, :poster_id, :posted_by_id
  end
end

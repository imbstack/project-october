class AddIndiciesToPosters < ActiveRecord::Migration
  def up
    # the three indices on the old users table
    add_index :posters, :email
    add_index :posters, [:name, :type], :unique => true
    add_index :posters, :reset_password_token
    add_index :posters, :url
  end

  def down
    # I don't feel like putting the corresponding remove_index things here, too
    # bad if you actually don't want these indices, you've got them forever.
  end
end

class RemoveUserIdFromFeed < ActiveRecord::Migration
  def up
    remove_column :feeds, :user_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

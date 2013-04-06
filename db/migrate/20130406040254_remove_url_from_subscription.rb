class RemoveUrlFromSubscription < ActiveRecord::Migration
  def up
    remove_column :subscriptions, :url
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

class RemoveAllSubscriptions < ActiveRecord::Migration
  def up
    Subscription.delete_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

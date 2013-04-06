class AddFeedIdToSubscription < ActiveRecord::Migration
  def change
    change_table :subscriptions do |t|
      t.integer :feed_id
    end
  end
end

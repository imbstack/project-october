class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.string :url

      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :url
  end
end

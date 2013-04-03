class CreateVotes < ActiveRecord::Migration
  def up
    create_table :votes do |t|
      t.integer :post_id
      t.integer :user_id
      t.boolean :direction
    end

    add_index :votes, :post_id
    add_index :votes, :user_id
    add_index :votes, [:user_id, :post_id]
  end

  def down
    drop_table :votes
  end
end

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body

      t.integer :post_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end
  end
end

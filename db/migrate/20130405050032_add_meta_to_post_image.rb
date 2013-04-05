class AddMetaToPostImage < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.text :image_meta
    end
  end
end

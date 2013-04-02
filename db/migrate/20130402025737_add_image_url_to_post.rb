class AddImageUrlToPost < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.string :image_url
    end
  end
end

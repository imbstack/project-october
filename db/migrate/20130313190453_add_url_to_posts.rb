class AddUrlToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.string :url
    end
  end
end

class MakeUrlLonger < ActiveRecord::Migration
  def up
    change_column :posts, :url, :text, :limit => 1000
  end

  def down
    change_column :posts, :url, :string
  end
end

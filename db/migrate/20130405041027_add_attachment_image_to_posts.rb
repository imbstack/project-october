class AddAttachmentImageToPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :image_url
    change_table :posts do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :posts, :image
    add_column :posts, :image_url, :string, :default => '/images/original/missing.png'
  end
end

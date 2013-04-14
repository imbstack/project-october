class CreatePosters < ActiveRecord::Migration
  def up
    create_table :posters do |t|
      t.string   "name",                                      :null => false
      t.string   "email",                  :default => "",    :null => false
      t.string   "encrypted_password",     :default => "",    :null => false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.boolean  "debug_user",             :default => false
      t.string   "type"
      t.string   "url"

      t.timestamps
    end
  end

  def down
    drop_table :posters
  end
end

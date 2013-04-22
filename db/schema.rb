# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130416004342) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "post_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "followings", :force => true do |t|
    t.integer "follower_id"
    t.integer "following_id"
  end

  add_index "followings", ["follower_id"], :name => "index_followings_on_follower_id"

  create_table "posters", :force => true do |t|
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
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "posters", ["email"], :name => "index_posters_on_email"
  add_index "posters", ["name", "type"], :name => "index_posters_on_name_and_type", :unique => true
  add_index "posters", ["reset_password_token"], :name => "index_posters_on_reset_password_token"
  add_index "posters", ["url"], :name => "index_posters_on_url"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.text     "url",                :limit => 255
    t.integer  "poster_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_meta"
    t.string   "posted_by_type",                    :default => "User"
  end

  add_index "posts", ["poster_id"], :name => "index_posts_on_user_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "feed_id"
  end

  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "votes", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.boolean  "direction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["post_id"], :name => "index_votes_on_post_id"
  add_index "votes", ["user_id", "post_id"], :name => "index_votes_on_user_id_and_post_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end

class Poster < ActiveRecord::Base
  has_many :posts
  has_many :followings, :foreign_key => :follower_id
end

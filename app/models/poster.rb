class Poster < ActiveRecord::Base
  has_many :posts, :as => :posted_by
  has_many :followings, :foreign_key => :follower_id
end

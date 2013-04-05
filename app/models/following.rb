class Following < ActiveRecord::Base
  attr_accessible :follower_id, :following_id
end

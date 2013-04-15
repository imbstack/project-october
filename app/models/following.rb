class Following < ActiveRecord::Base
  attr_accessible :follower_id, :following_id

  after_create :backend_create

private
  def backend_create
    THRIFTCLIENT.userToUser(self.follower_id, Backend::Action::FOLLOW, self.following_id)
  end
end

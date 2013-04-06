class Subscription < ActiveRecord::Base
  attr_accessible :user_id, :feed_id

  belongs_to :user
  belongs_to :feed

  validates_presence_of :user_id, :feed_id
  validates_uniqueness_of :feed_id, :scope => :user_id
end

class Subscription < ActiveRecord::Base
  validates_uniqueness_of :url, :scope => :user_id

  attr_accessible :url, :user_id
end

class Subscription < ActiveRecord::Base
  validates_uniqueness_of :url, :scope => :user_id

  attr_accessible :url, :user_id

  belongs_to :user

  before_create :verify_url

private

  def verify_url
    valid = Subscription.where(:url => url).present?
    return true if valid

    feed = Feedzirra::Feed.fetch_and_parse(url)
    if feed.nil? || feed == 0
      errors.add(:url, "is not a valid feed!")
      return false
    end

    return true
  end
end

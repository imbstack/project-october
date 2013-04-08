class Feed < ActiveRecord::Base 
  attr_accessible :title

  has_many :subscriptions

  before_create :verify_url

  validates_uniqueness_of :url

private

  def verify_url
    feed = Feedzirra::Feed.fetch_and_parse(url)
    if feed.nil? || feed == 0
      errors.add(:url, "is not a valid feed!")
      return false
    else
      self.title = feed.title
    end
  end
end

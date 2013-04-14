class Feed < ActiveRecord::Base 
  attr_accessible :title

  has_many :subscriptions

  before_create :set_title

  validates_uniqueness_of :url

private

  def set_title
    title = attempt_to_get_title()
    if title.present?
      self.title = title
    end
  end

  def attempt_to_get_title
    feed = Feedzirra::Feed.fetch_and_parse(url)
    if feed.nil? || feed == 0
      errors.add(:url, "is not a valid feed!")
      return ''
    else
      return feed.title
    end
  end
end

class Feed < Poster
  attr_accessible :name, :url

  has_many :subscriptions

  before_create :set_name

  validates_uniqueness_of :url

private

  def set_name
    return if self.name.present?

    name = attempt_to_get_name()
    if name.present?
      self.name = name
    end
  end

  def attempt_to_get_name
    feed = Feedzirra::Feed.fetch_and_parse(url)
    if feed.nil? || feed == 0
      errors.add(:url, "is not a valid feed!")
      return ''
    else
      return feed.title
    end
  end
end

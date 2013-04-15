# encoding: UTF-8

class User < Poster
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
  has_many :votes

  after_create :backend_register

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates :name, :length => {:minimum => 3,
    :maximum => 25,
    :too_short => "Usernames must have at least %{count} characters",
    :too_long => "Usernames cannot have less than %{count} characters"}
  validates :name, :uniqueness => {:message => "This username already exists"}
  validate :name_cannot_have_whitespace
  validate :name_cannot_have_special_chars

  def vote(post, direction=Vote.UP)
    vote = post.votes.where(:user_id => id, :post_id => post.id).first_or_initialize
    vote.direction = direction
    if vote.save
      # TODO: add undo directions here
      if direction == Vote.UP
        THRIFTCLIENT.userToPost(id, Backend::Action::VOTE_UP, post.id)
      else
        THRIFTCLIENT.userToPost(id, Backend::Action::VOTE_DOWN, post.id)
      end
    end
  end

  def top_keywords(n = 10)
    THRIFTCLIENT.userTopTerms(id, n).sort_by { |_, v| v }.reverse
  end

  def add_keywords(ary)
    return THRIFTCLIENT.addUserTerms(id, ary)
  end

  def remove_keywords(ary)
    return THRIFTCLIENT.removeUserTerms(id, ary)
  end

  def needs_onboarding?
    THRIFTCLIENT.userTopTerms(id, 1).empty?
  end

  def can_follow?(other)
    return false if id == other.id
    return false if followings.pluck(:following_id).include?(other.id)

    true
  end

  def subscribe_to_feed(url)
    feed = Feed.where(:url => url).first_or_create
    return false unless feed.present?
    subscription = subscriptions.where(:feed_id => feed.id).first_or_create
    subscription.persisted?
  end

  class << self
    def search(query)
      terms = query.split(' ').first(10)
      results = Hash.new(0)
      terms.each do |t|
        User.where('name LIKE ?', "%#{t}%").limit(30).each do |u|
          results[u] = results[u] + 1
        end
      end
      results.sort_by { |_, v| v }.reverse.map(&:first)
    end
  end

  private
    def name_cannot_have_whitespace
      if name.present? && name.match(/\s/)
        errors[:username] << "cannot have spaces in it"
      end
    end

    def name_cannot_have_special_chars
      if name.present? && name.match(/[^\w-]/)
        errors[:username] << "cannot have special characters in it"
      end
    end

    def backend_register
      THRIFTCLIENT.addUser(self.id)
    end
end

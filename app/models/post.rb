# encoding: utf-8

class Post < ActiveRecord::Base
  attr_accessor :keywords, :images  # Only populated in Post.new_from_url()
  attr_accessible :title, :url, :image_url, :keywords, :images

  belongs_to :user

  has_many :comments
  has_many :votes

  validates_presence_of :user

  def type
    # Everything is square for now.
    :square_article
  end

  # Class methods (i.e. Post.recommendations_for(user, n) )
  class << self
    def recommendations_for(user, n=10)
      THRIFTCLIENT.recPosts(user.id).posts.map do |p|
        # Make some garbage posts if the returned ones don't exist
        Post.where(:id => p.post_id).first
      end
    end

    def new_from_url(url)
      post = Pismo::Document.new(url)
      images = post.images || []
      leader = post.lede # This is the first couple sentences.
      keywords = post.keywords(
        :minimum_score => 1,
        :stem_at => 2,
        :word_length_limit => 30,
        :limit => 500
      )
      oct_vec = keywords.map do |pair|
        Backend::Token.new(:t => pair[0], :f => pair[1])
      end

      Post.new(
        :title     => post.title,
        :image_url => images.first,
        :url       => url,
        :keywords  => oct_vec,
        :images    => images,
      )
    end
  end
end

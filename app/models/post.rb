# encoding: utf-8

class Post < ActiveRecord::Base
  attr_accessor :keywords, :images      # Only populated in Post.new_from_url()
  attr_accessible :title, :url, :keywords, :images
  has_attached_file :image, :styles => {
    :featured => "749x400",
    :square => '363'
  }

  belongs_to :posted_by, :polymorphic => true

  has_many :comments
  has_many :votes

  before_validation :set_image_if_necessary

  validates_presence_of :posted_by_id

  def types
    base = Set.new([:square_article])
    base.merge([:feature_article, :square_article_with_picture]) if image.present?
    base
  end

  def image_height_as_pct
    return 0 unless image.present?
    width, height = image.image_size.split('x').map(&:to_f)
    height / width
  end

  # Class methods (i.e. Post.recommendations_for(user, n) )
  class << self
    def recommendations_for(user, n=10)
      posts = THRIFTCLIENT.recPosts(user.id).posts.sort_by(&:weight).reverse
      if posts.empty?
        return Post.order('created_at DESC').first(n).map do |p|
          [p, p.types.include?(:square_article_with_picture) ? :square_article_with_picture : :square_article]
        end
      end

      post_weights = posts.inject({}) { |a, i| a.merge(i.post_id => i.weight) }
      posts = Post.find(posts.map(&:post_id)).sort_by { |p| post_weights[p.id] }.reverse

      # Frontpage display algorithm:
      # 1) Find the highest weighted story that is eligible to be a featured
      #    post. It is the featured post.
      # 2) All other articles are to be displayed with an image if possible in
      #    order according to weight.
      featured = posts.detect { |p| p.types.include?(:feature_article) }

      post_type_list = (posts - [featured]).map do |p|
        [p, p.types.include?(:square_article_with_picture) ? :square_article_with_picture : :square_article]
      end
      post_type_list.unshift([featured, :feature_article]) if featured.present?

      post_type_list
    end

    def new_from_url(url)
      images, title, leader, keywords = fetch_from_url(url)

      oct_vec = keywords.map do |pair|
        Backend::Token.new(:t => pair[0], :f => pair[1])
      end

      Post.new(
        :title     => title,
        :url       => url,
        :keywords  => oct_vec,
        :images    => images,
      )
    end

    def fetch_from_url(url)
      post = Pismo::Document.new(url)
      images = post.images || []
      leader = post.lede # This is the first couple sentences.
      keywords = post.keywords(
        :minimum_score => 1,
        :stem_at => 2,
        :word_length_limit => 30,
        :limit => 500
      )
      return [
        post.images || [],
        post.title,
        post.lede,
        keywords
      ]
    end
  end

private

  def set_image_if_necessary
    self.image = open(images.first) if image.blank? && images.present?
  end

end

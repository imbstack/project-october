# encoding: utf-8

class Post < ActiveRecord::Base
  attr_accessible :title, :url, :image_url

  has_many :comments
  has_many :votes

  # TODO: Remove this bit once we get real data
  FAKE_HEADLINES = [
    'Insatiable Water Droplet Barrels Down Windowpane Consuming Everything In Its Path',
    'Iran Promises To End Nuclear Program In Exchange For Detailed Diagram Of Atomic Bomb',
    'Danica Patrick Flooded With Fan Mail From Nation\'s Inspired Little Girl',
    'Obama, Congress Must Reach Deal On Budget By March 1, And Then April 1, And Then April 20, And Then April 28, And Then May 1',
    'Area Man Relieved To Hear State Of Union Still Strong',
    'Adele wins “Best Instrumental” and “Best Spoken Word Performance”',
    'Company’s sole black employee wishes coworkers would stop trying to talk to him about black history month',
    'Woman Rushed Into Cosmetic Surgery With 8 Glaring Flaws',
    "'Les Misérables' Takes Home Oscar For Most Sound",
    '240 Killed In Stampede After Bucketful Of Oscars Just Dumped On Stage',
    'Words With Friends addict keeps trying to use “AE”, “AA”, “XI”, “QI” and “JO” in a sentence'
  ]

  def type
    # Everything is square for now.
    :square_article
  end

  # Class methods (i.e. Post.recommendations_for(user, n) )
  class << self
    def recommendations_for(user, n=10)
      THRIFTCLIENT.recPosts(user.id).posts.map do |p|
        # TODO: Remove this bit.
        # Make some garbage posts if the returned ones don't exist
        Post.where(:id => p.post_id).first_or_create(
          :title => FAKE_HEADLINES[p.post_id]
        )
      end
    end
  end
end

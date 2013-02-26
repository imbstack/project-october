# encoding: utf-8

class Post < ActiveRecord::Base
  attr_accessible :title
  # TODO: Remove this bit once we get real data
  FAKE_HEADLINES = [
    'Desperate GOP reaches out to Sauron, Voldemort',
    'Saints coach Sean Payton suspended from coaching for one year',
    'Gingrich vows to keep going, looks for extra fifty states',
    'GOP punches self in eye, blames Dems',
    'Romney campaign announces plans to purchase Michigan',
    'Adele wins “Best Instrumental” and “Best Spoken Word Performance”',
    'Company’s sole black employee wishes coworkers would stop trying to talk to him about black history month',
    'Unemployment drops for fifth straight month, as economy continues to lean Democratic',
    'Gingrich campaign strategy to involve last-minute death ray construction',
    'Obama begins state of union speech decrying lack of DiCaprio nomination',
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

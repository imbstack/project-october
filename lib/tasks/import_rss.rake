require 'rss'
require 'open-uri'

def post_article(url, title, current_user)
  if Post.where(:url => url).exists?
    return [false, "Article already posted!"]
  end

  # Copy-pasted from posts controller D:
  begin
    post = Pismo::Document.new(url)
    images = post.images
    leader = post.lede # This is the first couple sentences.
    keywords = post.keywords(
      :minimum_score     => 1,
      :stem_at           => 2,
      :word_length_limit => 30,
      :limit             => 500
    )
  rescue
    return [false, "Could not fetch article."]
  end

  if keywords.empty?
    return [false, "Could not determine keywords."]
  end

  oct_vec = keywords.map do |pair|
    Backend::Token.new(:t => pair[0], :f => pair[1])
  end

  @post = Post.new(
    :title => title,
    :url => url,
  )

  if @post.save
    if THRIFTCLIENT.addPost(current_user.id, @post.id, oct_vec)
      return [true, "Article posted!   (Keywords: #{oct_vec.first(5).map(&:t).join(', ')})"]
    else
      return [false, "Could not save to backend database!"]
    end
  else
    return [false, "Could not save to frontend database!"]
  end
end

desc "Import Articles from Tom's RSS Feeds"
task :import_rss => :environment do
  current_user = User.where(:name => "rssbot").first_or_create(
    :email => 'tomdooner+rss@gmail.com',
    :password => (('A'..'Z').to_a + ('a'..'z').to_a).sample(45).join,
  )
  feeds = Subscription.select(:url).uniq

  feeds.each do |f|
    open(f.url) do |rss|
      feed = RSS::Parser.parse(rss)
      STDOUT.write "===========================================================\n"
      STDOUT.write "Title: #{feed.channel.title}\n"
      STDOUT.write "===========================================================\n"

      feed.items.each do |item|
        STDOUT.write "  Item: #{item.title}\n"
        STDOUT.write "        #{item.link}\n"
        success, msg = post_article(item.link, item.title, current_user)
        STDOUT.write "        #{success ? 'POSTED:' : 'FAILED:'} #{msg}\n"
      end
    end
  end
end

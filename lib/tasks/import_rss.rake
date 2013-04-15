require 'rss'
require 'open-uri'

def post_article(url, title, feed)
  if Post.where(:url => url).exists?
    return [false, "Article already posted!"]
  end

  begin
    @post = Post.new_from_url(url)
    @post.poster = feed
  rescue
    return [false, "Could not fetch article."]
  end
  return [false, "Could not determine keywords."] if @post.keywords.empty?

  if @post.save
    if THRIFTCLIENT.addPost(feed.id, @post.id, @post.keywords)
      return [true, "Article posted!   (Keywords: #{@post.keywords.first(5).map(&:t).join(', ')})"]
    else
      return [false, "Could not save to backend database!"]
    end
  else
    return [false, "Could not save to frontend database!"]
  end
end

desc "Import Articles from Tom's RSS Feeds"
task :import_rss => :environment do
  feeds = Feed.select('DISTINCT(url), *')

  feeds.each do |f|
    feed = Feedzirra::Feed.fetch_and_parse(f.url)
    STDOUT.write "===========================================================\n"
    STDOUT.write "Title: #{feed.title}\n"
    STDOUT.write "===========================================================\n"

    feed.entries.each do |item|
      STDOUT.write "  Item: #{item.title}\n"
      STDOUT.write "        #{item.url}\n"
      success, msg = post_article(item.url, item.title, f)
      STDOUT.write "        #{success ? 'POSTED:' : 'FAILED:'} #{msg}\n"
    end
  end
end

require 'rss'
require 'open-uri'

def post_article(url, title, current_user)
  if Post.where(:url => url).exists?
    return [false, "Article already posted!"]
  end

  begin
    @post = Post.new_from_url(url)
    @post.user_id = current_user.id
  rescue
    return [false, "Could not fetch article."]
  end
  return [false, "Could not determine keywords."] if @post.keywords.empty?

  if @post.save
    if THRIFTCLIENT.addPost(current_user.id, @post.id, @post.keywords)
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

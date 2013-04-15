class RemoveDuplicateSubscriptions < ActiveRecord::Migration
  def up
    s = Subscription.all
    s.group_by { |s| [s.feed_id, s.user_id] }.each do |(feed, user), subs|
      next if subs.length == 1
      subs.drop(1).map(&:delete)
    end
  end

  def down
    # no op
  end
end

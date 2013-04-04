module Backend
  module Recommender
    class Client
      def initialize(protocol); end

      def ping; "Pong" end

      def recPosts(user_id)
        Post.first(10)
      end

      def addUser(user_id)
        # don't do anything.
      end

      def addPost(user_id, post_id, raw_freq)
        # don't do anything.
      end

      def user_v_post(user_id, verb, post_id)
        # don't do anything.
      end

      def user_v_comment(user_id, verb, comment_id)
        # don't do anything.
      end
    end
  end

  class Token
    attr_accessor :t, :f

    def initialize(vals)
      @t = vals[:t] if vals.include?(:t)
      @f = vals[:f] if vals.include?(:f)
    end
  end
end

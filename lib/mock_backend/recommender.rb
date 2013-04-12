require 'ostruct'

module Backend
  module RecommenderMock
    class Client
      def initialize(protocol)
        @user_terms = Hash.new([])
      end

      def ping; "Pong" end

      def recPosts(user_id, n=10)
        posts = ::Post.first(n).map do |x|
          OpenStruct.new(:post_id => x.id, :weight => Random.rand() * 20)
        end
        OpenStruct.new(:posts => posts)
      end

      def textSearch(tokens, limit)
        recPosts(-1, limit).posts.inject({}) { |a,i| a.merge(i.post_id => i.weight) }
      end

      def addUserTerms(user_id, terms)
        @user_terms[user_id] = @user_terms[user_id] + terms
      end

      def userTopTerms(user_id, limit)
        @user_terms[user_id].first(limit).map { |t| [t, Random.rand() * 20] }
      end

      def method_missing(m, *args)
        true
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

class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @posts = Post.recommendations_for(current_user)
    @votes = current_user.votes.where(:post_id => @posts.map(&:first))
  end
end

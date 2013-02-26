class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @posts = Post.recommendations_for(current_user)
  end
end

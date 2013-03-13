class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end

  def new

  end

  def create
    flash[:notice] = "Okay, you have posted your article!"

    redirect_to root_url
  end
end

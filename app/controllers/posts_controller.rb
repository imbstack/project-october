class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end

  def new

  end

  def search
    @query = params[:search][:query]
    results = THRIFTCLIENT.textSearch(@query.split(' '), 50)
    @posts = Post.assign_types(results)
    @votes = current_user.votes.where(:post_id => @posts.map(&:first))
    @user_results = User.search(@query)
    render 'home/index'
  end

  def fetch
    return unless request.xhr?
    begin
      @post = Post.new_from_url(params[:url])
    rescue
      return render :json => { :error => 'Could not fetch!' }
    end
    return render :json => {
      :images => @post.images,
      :title => @post.title,
      :keywords => @post.keywords.map(&:t),
    }
  end

  def create
    begin
      @post = Post.new_from_url(params[:post][:url])
      @post.title = params[:post][:title] if params[:post][:title].present?
      @post.image = open(params[:post][:image_url]) if params[:post][:image_url].present?
      @post.posted_by = current_user
    rescue
      return redirect_to new_post_url, :flash => {
        :error => "Could not fetch article!"
      }
    end

    if @post.keywords.empty?
      return redirect_to new_post_url, :flash => {
        :error => "Could not determine article keywords!"
      }
    end

    if @post.save
      # TODO: Save the post to the db to get the second param and get the first from the current user
      if THRIFTCLIENT.addPost(current_user.id, @post.id, @post.keywords)
        redirect_to root_url, :flash => {
          :notice => "Success! Your article has been submitted."
        }
      else
        redirect_to new_post_url, :flash => { :error => "Could not add article to backend database!" }
      end
    else
      redirect_to new_post_url, :flash => { :error => "Could not add article to frontend database!" }
    end
  end

  def upvote
    @post = Post.find(params[:id])
    render :text => current_user.vote(@post, Vote.UP)
  end

  def downvote
    @post = Post.find(params[:id])
    render :text => current_user.vote(@post, Vote.DOWN)
  end
end

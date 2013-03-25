class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end

  def new

  end

  def create
    begin
      src = open(params[:post][:url]).read
    rescue
      return redirect_to new_post_url, :flash => {
        :error => 'Could not fetch article.'
      }
    end
    post = Pismo::Document.new(src)
    images = post.images
    title = post.title
    leader = post.lede # This is the first couple sentences.
    keywords = post.keywords(
      :minimum_score => 1,
      :stem_at => 2,
      :word_length_limit => 30,
      :limit => 500
    )
    #oct_vec = keywords.map do |pair|
    #  Backend::Token.new(:t => pair[0], :f => pair[1])
    #end

    # TODO: Save the post to the db to get the second param and get the first from the current user
    # THRIFTCLIENT.addPost(1, 1, oct_vec)

    respond_to do |format|
      format.html { render :text => [images, title, leader, keywords] }
    end

    # redirect_to root_url
  end
end

class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end

  def new

  end

  def create
    begin
      post = Pismo::Document.new(params[:post][:url])
      images = post.images
      title = post.title
      leader = post.lede # This is the first couple sentences.
      keywords = post.keywords(
        :minimum_score => 1,
        :stem_at => 2,
        :word_length_limit => 30,
        :limit => 500
      )
    rescue
      return redirect_to new_post_url, :flash => {
        :error => "Could not fetch article!"
      }
    end

    if keywords.empty?
      return redirect_to new_post_url, :flash => {
        :error => "Could not determine article keywords!"
      }
    end

    oct_vec = keywords.map do |pair|
      Backend::Token.new(:t => pair[0], :f => pair[1])
    end

    @post = Post.new(
      :title => title,
      :url => params[:post][:url],
    )

    if @post.save
      # TODO: Save the post to the db to get the second param and get the first from the current user
      if THRIFTCLIENT.addPost(current_user.id, @post.id, oct_vec)
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
end

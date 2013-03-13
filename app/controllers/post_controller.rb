require 'pismo'
require 'open-uri'
require 'thrift/gen-rb/recommender'

class PostController < ApplicationController
  # TODO: actually authenticate
  #before_filter :authenticate_user!

  def create
    begin
      src = open(params[:url]).read
    rescue
      # TODO: Do something here
      p "Do something here, Tom."
      return
    end
    post = Pismo::Document.new(src)
    images = post.images # TODO: Do something with these
    title = post.title
    leader = post.lede # This is the first couple sentences.  I don't know if we want these for the frontend or not...
    keywords = post.keywords({:minimum_score => 1, :stem_at => 2, :word_length_limit => 30, :limit => 500})
    oct_vec = keywords.map { | pair | Backend::Token.new({:t => pair[0], :f => pair[1]}) }
    THRIFTCLIENT.addPost(1, 1, oct_vec) # TODO: Save the post to the db to get the second param and get the first from the current user
    respond_to do |format|
      format.html { render :text => "Posted\n" }
    end
  end
end

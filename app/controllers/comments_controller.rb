class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @post = Post.find(params[:id])
    @comment = Comment.new(params[:comment])
    @comment.user = current_user

    # TODO: verify that @comment can be posted to @post - i.e. if @post.id
    # is an ancestor of the @comment.parent_id. This should be an easy check
    # with awesome_nested_set.

    if !@comment.save
      flash[:error] = "Could not post comment: #{@comment.errors.full_messages.first}"
    end

    redirect_to post_url(@post)
  end
end

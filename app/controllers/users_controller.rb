class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.where(:name => params[:id]).includes(:posts).first
    @keywords = @user.top_keywords(20)
    return redirect_to root_path, :flash => { :error => "Unknown User!" } unless @user.present?
  end

  def follow
    @user = User.find(params[:id])

    if current_user.followings.create(:following_id => @user.id)
      flash[:notice] = "Now following #{@user.name}"
    end

    redirect_to user_path(@user.name)
  end

  def unfollow
    @user = User.find(params[:id])

    if current_user.followings.where(:following_id => @user.id).delete_all
      flash[:notice] = "Stopped following #{@user.name}"
    end

    redirect_to user_path(@user.name)
  end

  def add_terms
    @user = User.find(params[:id])
    @user.add_keywords(params[:tags])
    flash[:notice] = "Okay, here are some articles that are more like that!"

    redirect_to root_path
  end
end

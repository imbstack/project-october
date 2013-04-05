class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.where(:name => params[:id]).includes(:posts).first
    return redirect_to root_url, :flash => { :error => "Unknown User!" } unless @user.present?
  end

  def follow
    @user = User.find(params[:id])

    if current_user.followings.create(:following_id => @user.id)
      flash[:notice] = "Now following #{@user.name}"
    end

    redirect_to user_url(@user.name)
  end

  def unfollow
    @user = User.find(params[:id])

    if current_user.followings.where(:following_id => @user.id).delete_all
      flash[:notice] = "Stopped following #{@user.name}"
    end

    redirect_to user_url(@user.name)
  end
end

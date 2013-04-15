class UserKeywordsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_and_ensure_correct_user!

  def create
    @user.add_keywords(params[:tags])

    flash[:notice] = "Okay, here are some articles that are more like that!"

    redirect_to root_path
  end

  def destroy
    @user.remove_keywords(params[:tags].split(','))

    flash[:notice] = "Okay, we won't show you any more articles like that."

    redirect_to keywords_user_path(@user.name)
  end

private
  def set_and_ensure_correct_user!
    @user = User.find(params[:id])

    if @user != current_user
      return redirect_to user_url(current_user.name), :flash => {
        :error => 'You cannot change keywords for this user!'
      }
    end
  end
end

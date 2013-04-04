class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.where(:name => params[:id]).includes(:posts).first
    return redirect_to root_url, :flash => { :error => "Unknown User!" } unless @user.present?
  end
end

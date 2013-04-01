class UserController < ApplicationController
  before_filter :authenticate_user!

  def view
    @user = User.find_by_name(params[:name])
  end
end

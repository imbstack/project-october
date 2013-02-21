class UserController < ApplicationController

  def view
    @user = User.find_by_name(params[:name])
  end
end

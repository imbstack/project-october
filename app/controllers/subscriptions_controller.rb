class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user = User.find(params[:user_id])

    if !@user.subscribe_to_feed(params[:feed][:url])
      flash[:error] = @subscription.errors.full_messages.first
    end

    return redirect_to edit_user_registration_path
  end

  def destroy
    @subscription = Subscription.find(params[:id])

    if @subscription.user_id == current_user.id
      @subscription.delete
      return redirect_to edit_user_registration_path
    else
      return redirect_to edit_user_registration_path, :flash => {
        :error => "You cannot delete this RSS Feed Subscription"
      }
    end
  end
end

class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    @user.subscriptions.create(:url => params[:subscription][:url])
    return redirect_to edit_user_registration_url
  end

  def destroy
    @subscription = Subscription.find(params[:id])

    if @subscription.user_id == current_user.id
      @subscription.delete
      return redirect_to edit_user_registration_url
    else
      return redirect_to edit_user_registration_url, :flash => {
        :error => "You cannot delete this RSS Feed Subscription"
      }
    end
  end
end

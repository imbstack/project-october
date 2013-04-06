class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    @subscription = @user.subscriptions.new(:url => params[:subscription][:url])
    if !@subscription.save
      flash[:error] = @subscription.errors.full_messages.first
    end

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

class ApplicationController < ActionController::Base
  protect_from_forgery

  def setup
    Time.zone = 'Eastern Time (US & Canada)'
  end

  def ensure_debug!
    redirect_to root_url, :flash => { :error => 'You cannot view that page!' } unless current_user.try(:debug_user)
  end
end

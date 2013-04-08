class ApplicationController < ActionController::Base
  protect_from_forgery

  def setup
    Time.zone = 'Eastern Time (US & Canada)'
  end
end

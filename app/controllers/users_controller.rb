class UsersController < Devise::RegistrationsController
  before_filter :authenticate_user!
  layout "splash", :only => :new

  def show
    if request.fullpath.match(/\A\/feed/)
      @user = Feed.find(params[:id])
    else
      @user = User.where(:name => params[:id]).includes(:posts).first
    end

    return redirect_to root_path, :flash => { :error => "Unknown User!" } unless @user.present?
  end

  def follow
    @user = Poster.find(params[:id])

    if current_user.followings.create(:following_id => @user.id)
      flash[:notice] = "Now following #{@user.name}"
    end

    redirect_to feed_path(@user.id) if @user.is_a?(Feed)
    redirect_to user_path(@user.name) if @user.is_a?(User)
  end

  def unfollow
    @user = Poster.find(params[:id])

    if current_user.followings.where(:following_id => @user.id).delete_all
      flash[:notice] = "Stopped following #{@user.name}"
    end

    redirect_to feed_path(@user.id) if @user.is_a?(Feed)
    redirect_to user_path(@user.name) if @user.is_a?(User)
  end

  def keywords
    @user = User.where(:name => params[:id]).first
    @keywords = @user.top_keywords(20)
  end

  # From Devise:
  # POST /resource
  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        UserMailer.welcome_email(resource).deliver
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      flash[:error] = resource.errors.full_messages.first
      redirect_to new_user_registration_path
    end
  end
end

class UsersController < Devise::RegistrationsController
  before_filter :authenticate_user!

  def show
    @user = User.where(:name => params[:id]).includes(:posts).first
    return redirect_to root_path, :flash => { :error => "Unknown User!" } unless @user.present?
  end

  def follow
    @user = User.find(params[:id])

    if current_user.followings.create(:following_id => @user.id)
      flash[:notice] = "Now following #{@user.name}"
    end

    redirect_to user_path(@user.name)
  end

  def unfollow
    @user = User.find(params[:id])

    if current_user.followings.where(:following_id => @user.id).delete_all
      flash[:notice] = "Stopped following #{@user.name}"
    end

    redirect_to user_path(@user.name)
  end

  def add_terms
    @user = User.find(params[:id])
    @user.add_keywords(params[:tags])
    flash[:notice] = "Okay, here are some articles that are more like that!"

    redirect_to root_path
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
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end

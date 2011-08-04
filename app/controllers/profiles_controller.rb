class ProfilesController < ApplicationController
  #load_and_authorize_resource :through => :user
  
  def show
    @profile = Profile.new
  end

  def new
  end
  
  def edit
    @profile = current_user.profile
  end

  def update
    if current_user.profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated profile."
    else
      render "edit"
    end
  end

  def destroy
  end

end

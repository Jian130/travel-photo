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

  def create
  end

  def update
  end

  def destroy
  end

end

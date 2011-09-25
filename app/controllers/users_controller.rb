class UsersController < ApplicationController

  
  def show
    #@user = User.find_by_id(params[:id], :include => :profile)
    if params[:username]
      @profile = Profile.find_by_username(params[:username])
      @posts = @profile.user.photos
    else
      @user = current_user || User.find_by_id(params[:id], :include => :profile)
      @posts = @user.posts
    end
  end
  
  def new
    @user = User.new
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
    end
  end
  
  #TODO: signup with external provider can bypass password
  def create
    @user = User.new(params[:user])
    @user.create_profile(params[:user][:profile])
    
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
    
    if @user.save
      session[:omniauth] = nil
      signin(@user)
      redirect_to user_path(current_user), :notice => t('signup')
    else
      render "new"
    end
  end
  
  def following
  end
  
  def followers
  end
end

class UsersController < ApplicationController
  
  def index
    @users = User.find(:all, :include => :profile)
  end
  
  def show
    #@user = User.find_by_id(params[:id], :include => :profile)
    @user = current_user || User.find_by_id(params[:id], :include => :profile)
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
      login(@user)
      redirect_to root_url, :notice => t('signup')
    else
      render "new"
    end
    
  end
end

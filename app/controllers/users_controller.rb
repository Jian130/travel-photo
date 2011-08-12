class UsersController < ApplicationController
  
  def index
  end
  
  def show
    @user = User.find_by_id(params[:id])
  end
  
  def new
    @user = User.new
  end
  
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
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
    
  end
end

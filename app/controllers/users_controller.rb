class UsersController < ApplicationController
  
  def show
    @user = User.find_by_id(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
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

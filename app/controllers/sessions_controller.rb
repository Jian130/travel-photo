class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
            
    if user && user.authenticate(params[:session][:password])   
      flash.now.alert = "Logged in!"
      login(user)
      redirect_to root_url
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end
  
  def destroy
    #session[:user_id] = nil
    logout
    redirect_to root_url, :notice => "Logged out!"
  end
end

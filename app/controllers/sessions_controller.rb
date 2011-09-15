class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
            
    if user && user.authenticate(params[:session][:password])   
      signin(user)
      redirect_to user, :notice => t('success.signin')
    else
      flash[:notice] = t('error.signin')
      render "new"
    end
  end
  
  def destroy
    #session[:user_id] = nil
    signout
    redirect_to root_url, :notice => t('signout')
  end
end

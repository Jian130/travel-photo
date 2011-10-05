class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        signin_remember(user)
      else
        signin(user)
      end
      redirect_to user, :notice => t('success.signin')
    else
      flash.now.alert = t('error.signin')
      render "new"
    end
  end
  
  def destroy
    signout
    redirect_to root_url, :notice => t('signout')
  end
end

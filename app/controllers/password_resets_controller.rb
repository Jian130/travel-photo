class PasswordResetsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, :notice => t("email.password_reset")
  end

  def edit
    @user = User.find_by_passwor_reset_token!(params[:id])
  end
  
  def update
    
  end
end

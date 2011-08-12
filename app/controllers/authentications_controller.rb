class AuthenticationsController < ApplicationController
  def index
  end

  def create
	#raise request.env["omniauth.auth"].to_yaml
    omniauth = request.env["omniauth.auth"]
    auth = Authentication.find_by_provider_and_uid(omniauth["provider"], omniauth["uid"])
    if auth
      login(auth.user)
      flash[:notice] = "Signed in successfully!"
      redirect_to root_path
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to root_path
    else
      user = User.new
      user.apply_omniauth(omniauth)
    
      if user.save
        flash[:notice] = "Signed in successfully!"
        redirect_to root_path
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to register_path
      end
    end
  end

  def destory
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to root_path
  end

  def failure
    
    render :text => request.env["omniauth.auth"].to_yaml
  end
end

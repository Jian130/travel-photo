module SessionsHelper
  
  def signin(user)
    #session[:user_id] = user.id
    cookies[:auth_token] = user.auth_token
    self.current_user = user
  end
  
  def signin_remember(user)
    cookies.permanent[:auth_token] = user.auth_token
    self.current_user = user
  end
  
  def signout
    #session[:user_id] = nil
    cookies.delete(:auth_token)
    self.current_user = nil
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_session
  end
  
  def signin?
    !current_user.nil?
  end
  
  private
    
    def user_from_session
      #User.find_by_id(session[:user_id]) if session[:user_id]
      User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end
  
end

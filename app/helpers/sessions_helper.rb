module SessionsHelper
  
  def login(user)
    session[:user_id] = user.id
    self.current_user = user
  end
  
  def logout
    session[:user_id] = nil
    self.current_user = nil
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_session
  end
  
  def login?
    !current_user.nil?
  end
  
  private
    
    def user_from_session
      User.find_by_id(session[:user_id]) if session[:user_id]
    end
  
end

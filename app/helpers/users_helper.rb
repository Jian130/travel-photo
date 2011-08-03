module UsersHelper
  
  def authenticate
    deny_access unless login?
  end
end

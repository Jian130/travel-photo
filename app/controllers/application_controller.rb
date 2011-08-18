class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include SessionsHelper
  
  before_filter :set_user_language
  
  private
  
    def set_user_language
      I18n.locale = current_user.profile.locale if (signin? && !current_user.profile.locale.nil?)
    end
  
end

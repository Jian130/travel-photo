class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  
  has_secure_password
  
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :password, :on => :create
  
  has_many :authentications
  has_one :profile
  
  before_create :create_profile
  
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  private
  
    def create_profile
      self.build_profile
    end
end

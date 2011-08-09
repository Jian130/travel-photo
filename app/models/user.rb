class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  
  has_secure_password
  
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :password, :on => :create
  
  has_many :authentications
  has_one :profile
  
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  has_many :posts
  has_many :photos
  
  before_create :create_profile
  
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def following?(followed)
    self.relationships.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id)
    Profile.increment_counter(:followings_count, self.profile.id)
    Profile.increment_counter(:followers_count, User.find_by_id(followed.id).profile.id)
  end  
  
  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed).destroy
    Profile.decrement_counter(:followers_count, User.find_by_id(followed.id).profile.id)
    Profile.decrement_counter(:followings_count, self.profile.id)
  end
  
  private
  
    def create_profile
      self.build_profile
    end
end

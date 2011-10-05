class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  
  has_secure_password
  
  before_create { generate_token(:auth_token) }
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, :presence => true,
                    :length => { :in => 5..254},
                    :uniqueness => { :case_sensitive => false },
                    :format => { :with => email_regex }
  
  validates :password, :presence => true,
                       :length => { :minimum => 6 },
                       :on => :create
                       #:unless => :no_password?
  has_one :profile
  has_many :authentications
  has_many :posts
  has_many :photos
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  
  delegate :username, :to => :profile
  
  #TODO: insert extra information to user profile from external provider
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
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  private
    
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
    # def create_profile
    #   self.build_profile
    # end
end

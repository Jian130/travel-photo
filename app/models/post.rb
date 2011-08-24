class Post < ActiveRecord::Base
  
  attr_accessible :message
  
  belongs_to :user
  has_many :photos
  belongs_to :location, :counter_cache => true
  has_many :likes, :as => :likeable
  has_many :comments, :as => :commentable
  #acts_as_taggable
  
  validates :message, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  #should use rate, add rate column to Post later
  default_scope :order => 'posts.created_at DESC'
  
  before_save :increment_cache
  
  private
    def increment_cache
      Profile.increment_counter(:posts_count, self.user.profile.id)
    end
end

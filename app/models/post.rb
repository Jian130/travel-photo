class Post < ActiveRecord::Base
  
  attr_accessible :message
  
  belongs_to :user
  has_many :photos
  belongs_to :location, :counter_cache => true
  
  #acts_as_taggable
  
  validates :message, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  #should use rate, add rate column to Post later
  default_scope :order => 'posts.created_at DESC'
  
end

class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  
  belongs_to :follower, :class_name => "User" #, :counter_cache => :followers_count
  belongs_to :followed, :class_name => "User" #, :counter_cache => :followings_count
  
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end

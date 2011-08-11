class Profile < ActiveRecord::Base
  attr_accessible :username, :first_name, :last_name, :timezone, :locale, :bio, :web
  
  belongs_to :user 
  has_many :likes, :as => :likeable
end

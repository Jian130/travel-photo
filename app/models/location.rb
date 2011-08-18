require 'google_place.rb'

class Location < ActiveRecord::Base
  has_many :post
  belongs_to :parent, :class_name => 'Location', :foreign_key => 'parent_id'
  
  before_validation :load_from_external, :on => :create
  after_find :load_from_external, :if => :refresh_expired?
  
  def suggestions (query, location, radius = 4000000)
    searcher.suggestions(query, location, radius)
  end
  
  protected
  
  def load_from_external
    if attribute_present?('reference')
      details = searcher.find(self.reference)
      
      self.name = details[:name]
      self.vicinity = details[:vicinity]
      self.phone = details[:phone]
      self.address = details[:address]
      self.latitude = details[:latitude]
      self.longitude = details[:longitude]
      self.link = details[:link]
      self.google_id = details[:id]
      self.refreshed_at = Time.now
      #details[:parent]
      #details[:categories]
    end
  end
  
  # TODO: make expired time configurable 
  def refresh_expired? (day = 1)
    Time.zone.now > self.refreshed_at + day.day
  end
  
  def searcher
    LocationDatabase::GooglePlace.new(APP_CONFIG['google_api_key'])
  end
end

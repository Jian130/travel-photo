class LocationsController < ApplicationController
  def search (lng, lat, distance, query)
    
  end
  
  def autocomplete
    #ip = request.location
    logger.info params[:ll]
    #ll = params[:ll] || 
	ll = Geocoder.search('205.250.126.197').first.coordinates.join(',')
    radius = params[:ll]? 300 : 2000000
    render :json => Location.new.suggestions(params[:q], ll)
  end
  
  def show
    @location = Location.find(params[:id])
  end
  
end

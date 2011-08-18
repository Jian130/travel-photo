require 'httparty'

module LocationDatabase
  class GooglePlace
    include HTTParty
    base_uri 'https://maps.googleapis.com/maps/api/place/'
    format :json
    
    def initialize (key, language = 'en')
      @api_key = key
      @language = language
    end
    
    
    def find (reference)
      if reference.present?
        details = self.details(reference)
        parents = details['address_components'][1..-1].select { |a| a['types'].include?('locality') || a['types'].include?('administrative_area_level_1') || a['types'].include?('country') }
        {
          :reference => details['reference'],
          :id => details['id'],
          :name => details['name'],
          :vicinity => details['vicinity'],
          :phone => details['formatted_phone_number'],
          :address => details['formatted_address'],
          :latitude => details['geometry']['location']['lat'],
          :longitude => details['geometry']['location']['lng'],
          :link => details['url'],
          :categories => details['types'],
          :parent => (parents.first['long_name'] if parents.present?)
        }
      end
    end
    
    def suggestions (input = '', location = '', radius = 500)
      results = []
      
#      if input.present?
#        self.autocomplete(input, location, radius).each do |p|
#          results.push({
#            :id => p['id'] + '|' + p['reference'],
#            :name => p['terms'][0]['value'],
#            #:full => p['description'],
#            :description => p['terms'][1..-1].collect {|t| t['value']}.join(', ') # join the rest of the terms
#          })
#        end
#      else  
        self.search(location, input, radius).each do |p|
          results.push({
            :id => p['id'] + '|' + p['reference'],
            :name => p['name'],
            #:full => p['name'],
            :description => p['vicinity'] || ''
          })
        end
#      end
      
      return results
    end
    
    protected
    
    def process_request (url, params, container)
      response = self.class.get(url, :query => params)#url, :query => params)
      raise "GooglePlaceAPI::ERROR: " + response['status'] if response.has_key?('status') && response['status'] != 'OK'
      response[container]
    end
    
    def details (reference, format = 'json'   )
      params = {
        :reference => reference,
        :sensor => false,
        :key => @api_key,
        :language => @language
      }
      self.process_request("/details/#{format}", params, 'result')
    end
    
    def search (location, input = '', radius = 500, format = 'json')
      params = {
        :name => input,
        :sensor => false,
        :key => @api_key,
        :location => location,
        :radius => radius,
        :language => @language
      }
      self.process_request("/search/#{format}", params, 'results')
    end
    
    def autocomplete (input, location = '', radius = 500, format = 'json')
      params = {
        :input => input,
        :sensor => true,
        :key => @api_key,
        :location => location,
        :radius => radius,
        :language => @language
      }
      self.process_request("/autocomplete/#{format}", params, 'predictions')
    end
  end
end

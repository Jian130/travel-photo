# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Travelphoto::Application.initialize!

# Rails::Initializer.run do |config|  
#   config.middleware.use "Locale"
# end

# Travelphoto::Application.configure do
#   config.middleware.use "ResponseTimer"
#   config.middleware.use "Locale"
# end
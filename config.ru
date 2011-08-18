# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require 'middleware/locale'
#require 'response_timer'

use Locale
#use ResponseTimer

run Travelphoto::Application
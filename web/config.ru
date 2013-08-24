require 'sinatra/base'
require './web/helpers/application_helper.rb'
require './web/controllers/application_controller'

require './web/controllers/disc_jockey_controller'

map('/') { run DiscJockeyController }
